//
//  Scan_ViewModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import AVFoundation
import MicroBlink
import SwiftMessages
import RealmSwift
import RxDataSources

final class Scan_ViewModel: NSObject, Scan_ViewModelType, ScanResults_ViewModelType {
    //------------ COMMON -----------------
    let message = PublishSubject<Message>()
    private let disposeBag = DisposeBag()
    
    //------------ STATUS -----------------
    let scannerStateSubject = BehaviorSubject<ScannerState>(value: .tearUp)
    private let flashlightStateSubject = BehaviorSubject<FlashlightState>(value: .off)
    private let isFetchingProductDataSubject = BehaviorSubject<Bool>(value: false)
    
    //  Validation
    lazy var productValidationStateObservable: Observable<ValidationState> = self.productSubject.map({ self.validate(product: $0) })
    lazy var dateValidationStateObservable: Observable<ValidationState> = self.dateSubject.map({ self.validate(date: $0) })
    lazy var scanDataState: Observable<ScanDataState> = Observable
        .combineLatest(
            self.dateValidationStateObservable,
            self.productValidationStateObservable
        )
        .map({
            switch $0 {
            case let (dateState, productState) where dateState == .success && productState == .success:
                return .all
            case let (dateState, productState) where dateState == .standard && productState == .standard:
                return .none
            default:
                return .some
            }
        })
    
    //------------ STATUS OBSERVABLES ------------
    lazy var flashlightStateObservable = self.flashlightStateSubject.asObservable()

    //------------ DATA --------------------
    let scannedItemsSubject = BehaviorSubject<[FoodItem]>(value: [])
    let dateSubject = BehaviorSubject<Date?>(value: nil)
    let amountSubject = BehaviorSubject<Int>(value: 1)
    let roiSubject = BehaviorSubject<CGRect>(value: .one)
    
    private let productSubject = BehaviorSubject<Product?>(value: nil)
    private let productIDSubject = BehaviorSubject<String?>(value: nil)
    
    //------------ DATA OBSERVABLES ------------
    lazy var productObservable: Observable<Product?> = self.productSubject.asObservable()
    
    //------------ WORKER -------------------
    internal let gtinRecognizer = BarcodeRecognizer()
    internal lazy var dateRecognizer = DateRecognizer(validator: { self.validate(date: $0) == .success })
    
    //----------- RESULTS VIEW  -------------
    lazy var results_sections: Observable<[ScanResults_SectionModel]> = self.results_sectionsSubject.asObservable()
    private let results_sectionsSubject = BehaviorSubject<[ScanResults_SectionModel]>(value: [])
    
    var results_tableDataSource: RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>!
    
    //------------ LIFECYCLE ------------
    override init() {
        super.init()
        self.resetScanData()
        self.linkScanData()
        self.linkResultsTableData()        
    }
    
    private func linkScanData() {
        
        //  product <~> productID: stay in sync with product objects <- for thread save realm operations
        productSubject
            .map({ $0?.id })
            .bind(to: productIDSubject)
            .disposed(by: disposeBag)
        
        
        //  additionally pause date recognizer if we have valid date
        //  e.g. if date was choosen manually
        dateValidationStateObservable
            .filter({ $0 == .success })
            .subscribe { [weak self] in
                self?.dateRecognizer.pause()
            }
            .disposed(by: disposeBag)
        
        
        //  Check Date recognizer state
        dateRecognizer
            .stateObservable
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                switch state {
                case .ready: break
                case .result(let result):
                    guard strong.validate(date: result) == .success else { return }
                    strong.dateSubject.onNext(result)
                    strong.dateRecognizer.pause()
                case .error(let error):
                    strong.message.onNext(Message(type: .error, title: "Date Recognizer Error", message: error.localizedDescription))
                }
            }
            .disposed(by: disposeBag)
        
        //  Check GTIN recognizer state
        gtinRecognizer
            .stateObservable
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                
                switch state {
                case .ready: break
                case .result(let result):
                    guard strong.validate(gtin: result) else { return }
                    strong.gtinRecognizer.pause()
                    strong.handleGTINResult(result)
                case .error(let error):
                    strong.message.onNext(Message(type: .error, title: "Barcode Recognizer Error", message: error.localizedDescription))
                }
            }
            .disposed(by: disposeBag)
        
        //  Pseudo data in simulator
        if Platform.isSimulator { setPseudoData() }
    }
    
    private func setPseudoData() {
        Stores.products.product(withID: "8718114715162") { [weak self] in
            guard let strong = self else { return }
            switch $0 {
            case .success(let product):
                strong.productSubject.onNext(product)
            case .failure(let error):
                strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
            }
        }
        dateSubject.onNext(Date().addingTimeInterval(60*60*24))
    }
    
    private func linkResultsTableData() {
        scannedItemsSubject
            .map({ [ScanResults_SectionModel(header: "Scanned Items", items: $0, footer: "")] })
            .bind(to: results_sectionsSubject)
            .disposed(by: disposeBag)
    }
    
    private var productUpdateToken: NotificationToken?
    private func handleGTINResult(_ result: String) {
        guard let isFetching = try? isFetchingProductDataSubject.value() else { return }
        
        if !isFetching {
            isFetchingProductDataSubject.onNext(true)
            Stores.products.product(withID: result) { [weak self] in
                defer { self?.isFetchingProductDataSubject.onNext(false) }
                
                guard let strong = self else { return }
                switch $0 {
                case .success(let product):
                    strong.productSubject.onNext(product)
                case .failure(let error):
                    strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
                }
            }
        }
    }
    
    func addItemToList() {
        //  Get values
        guard let dateValue = try? dateSubject.value(),
            let productIDValue = try? productIDSubject.value(),
            let amount = try? amountSubject.value(),
            var scannedItems = try? scannedItemsSubject.value()
        else { return }
        
        //  Unwrap product and date
        guard let date = dateValue,
            let productID = productIDValue
        else { return }
        
        let item = FoodItem(bestBeforeDate: date, productID: productID, amount: amount)
        scannedItems.append(item)
        
        scannedItemsSubject.onNext(scannedItems)
        resetScanData()
        
        //  Pseudo data in simulator
        if Platform.isSimulator { setPseudoData() }
    }
    
    func removeItem(at indexPath: IndexPath) {
        guard var scannedItems = try? scannedItemsSubject.value() else { return }
        scannedItems.remove(at: indexPath.row)
        scannedItemsSubject.onNext(scannedItems)
    }

    //------------ VALIDATION ------------
    private func validate(gtin: String?) -> Bool {
        guard gtin != nil else { return false }
        return GTINValidator.validate(gtin!)
    }
    
    private func validate(product: Product?) -> ValidationState {
        guard product != nil else { return .standard }
        return .success
    }
    
    private func validate(date: Date?) -> ValidationState {
        guard let date = date else { return .standard }
        let range = DateRange(Date(), Date().addingTimeInterval(60*60*24*7*52*5)) // 5 Years
        return date.isInRange(range) ? .success : .error
    }
    
    //------------ EXTRA BEHAVIOR ------------
    func toggleFlashlight() {
        guard let state = try? flashlightStateSubject.value() else { return }
        switch state {
        case .on, .dimmed(_):
            flashlightStateSubject.onNext(.off)
        case .off:
            flashlightStateSubject.onNext(.on)
        }
    }
    
    func resetScanData() {
        dateSubject.onNext(nil)
        productSubject.onNext(nil)
        amountSubject.onNext(1)
        dateRecognizer.reset()
        gtinRecognizer.reset()
        
        scannerStateSubject.onNext(.ready)
    }

    //------------ RESULTS VIEW ------------
    func item(at indexPath: IndexPath) -> ScanResults_SectionModel.Item? {
        guard let sections = try? self.results_sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
        else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
    

    func saveScanResults(_ completion: (Bool) -> Void) {
        guard let sectionsValue = try? self.results_sectionsSubject.value() else { return }
        
        sectionsValue.map({ $0.items }).flatMap({ $0 }).forEach {
            Stores.items.save($0) {
                switch $0 {
                case .failure(let error):
                    self.message.onNext(Message(type: .error, title: "Save Error", message: error.localizedDescription))
                default: break
                }
            }
        }
        
        completion(true)
    }
    
    func updateItem(old: FoodItem, new: FoodItem) {
        guard old != new,
            var actualItems = try? scannedItemsSubject.value(),
            let index = actualItems.enumerated().filter({ $0.element == old }).first?.offset
        else { return }
        
        actualItems[index] = new
        
        scannedItemsSubject.onNext(actualItems)
    }
}



