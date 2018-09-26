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

final class Scan_ViewModel: NSObject, Scan_ViewModelType {    
    let message = PublishSubject<Message>()
    let disposeBag = DisposeBag()
    
    var cameraAvailable = BehaviorSubject<Bool>(value: true)
    var isCapturing = BehaviorSubject<Bool>(value: false)
    var isFlashlightOn = BehaviorSubject<Bool>(value: false)
    
    lazy var gtin: Observable<String?> = self.gtinSubject.asObservable()
    private let gtinSubject = BehaviorSubject<String?>(value: nil)
    
    lazy var productName: Observable<String?> = self.productNameSubject.asObservable()
    private let productNameSubject = BehaviorSubject<String?>(value: nil)
    
    let date = BehaviorSubject<Date?>(value: nil)
    lazy var dateViewState: Observable<ViewState> = self.date
        .map({
            guard let date = $0 else { return .standard }
            return self.isValidDate(date) ? .success : .error            
        })
    
    private lazy var combinedDataSubject = Observable
        .combineLatest(self.gtin, self.date.asObservable())
    
    let scannedItems = BehaviorSubject<[FoodItem]>(value: [])
    
    private let scanEnabled = BehaviorSubject<Bool>(value: true)

    private let gtinRecognizer = BarcodeRecognizer()
    private let dateRecognizer = DateRecognizer()
    
    private var isValidDate: (Date) -> Bool = { date in
        let range = DateRange(Date(), Date().addingTimeInterval(60*60*24*7*52*5)) // 5 Years        
        return date.isInRange(range)
    }
    
    override init() {
        super.init()
        self.linkData()
        
    }
    
    private func linkData() {
        combinedDataSubject
            .debug()
            .filter({ [weak self] in
                guard
                    let strong = self,              //  weak reference
                    let _ = $0.0,                   //  GTIN != nil
                    let date = $0.1,                //  Date != nil
                    strong.isValidDate(date),       //  Date is valid
                    try! strong.scanEnabled.value() //  can scan next element
                else { return false }
                return true
            })
            .debug()
            .subscribe { [weak self] next in
                guard let strong = self,
                    var prevItems = try? strong.scannedItems.value(),   // get actual elements
                    let (nextGtin, nextDate) = next.element             // deconstruct combined data
                else { return }
                
                strong.scanEnabled.onNext(false)                        // disable next element until done
                
                FoodFactory
                    .prepareFoodItem(productID: nextGtin!, bestBeforeDate: nextDate!, { (result) in
                        switch result {
                        case .success(let foodItem):
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                prevItems.append(foodItem)
                                strong.scannedItems.onNext(prevItems)
                                strong.gtinRecognizer.reset()
                                strong.dateRecognizer.reset()
                                strong.gtinSubject.onNext(nil)
                                strong.date.onNext(nil)
                                
                                strong.scanEnabled.onNext(true)
                            })
                        case .failure(let error):
                            strong.message.onNext(Message(type: .error, title: "FoodFactoryError", text: error.localizedDescription))
                        }
                    })
            }
            .disposed(by: disposeBag)
        
        gtin
            .subscribe { [weak self] next in
                guard let strong = self,
                    let element = next.element
                else { return }
                
                if let gtin = element {
                    FoodFactory.makeProduct(gtin, { (result) in
                        switch result {
                        case .success(let product):
                            log.debug("Can update product name: \(product.name)")
                            strong.productNameSubject.onNext(product.name)
                        case .failure(let error):
                            strong.message.onNext(Message(type: .error, title: "ProductDataError", text: error.localizedDescription))
                        }
                    })
                } else {
                    strong.productNameSubject.onNext(nil)
                }                
            }
            .disposed(by: disposeBag)
        
        dateRecognizer
            .stateObservable
            .subscribe { next in
                guard let state = next.element else { return }
                switch state {
                case .ready:
                    log.debug("DateRecognizer is ready")
                case .result(let result):
                    self.date.onNext(result)
                case .error(let error):
                    log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        gtinRecognizer
            .stateObservable
            .subscribe { next in
                guard let state = next.element else { return }
                switch state {
                case .ready:
                    log.debug("GTINRecognizer is ready")
                case .result(let result):
                    self.gtinSubject.onNext(result)
                case .error(let error):
                    log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        switch dateRecognizer.state {
        case .ready:
            self.dateRecognizer.process(sampleBuffer)
        default: break
        }
        
        switch gtinRecognizer.state {
        case .ready:
            self.gtinRecognizer.process(sampleBuffer)
        default: break
        }
    }
}
