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

final class Scan_ViewModel: NSObject, Scan_ViewModelType {
    
    //------------ PUBLIC ------------
    let message = PublishSubject<Message>()
    lazy var resultShowProgress: Observable<Float> = self.resultShowProgressSubject.asObservable()

    private let resultShowProgressSubject = BehaviorSubject<Float>(value: 0.0)
    let scannerState = BehaviorSubject<ScannerState>(value: .tearUp)
    let flashlightState =  BehaviorSubject<FlashlightState>(value: .off)
    
    let scannedItems = BehaviorSubject<[FoodItem]>(value: [])
    
    lazy var productValidationState: Observable<ValidationState> = self.productSubject.map({ self.validate(product: $0) })
    lazy var dateValidationState: Observable<ValidationState> = self.dateSubject.map({ self.validate(date: $0) })
    
    //------------ PRIVATE ------------
    private let gtinRecognizer = BarcodeRecognizer()
    private let dateRecognizer = DateRecognizer()
    
    let dateSubject: BehaviorSubject<Date?> = BehaviorSubject<Date?>(value: nil)
    
    lazy var product: Observable<Product?> = self.productSubject.asObservable()
    private let productSubject = BehaviorSubject<Product?>(value: nil)
    
    private let isFetchingProductData = BehaviorSubject<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    //------------ LIFECYCLE ------------
    override init() {
        super.init()
        self.resetScanData()
        self.linkData()
    }
    
    private func linkData() {
        Observable
            .combineLatest(                                     //  observe ScannerState, Product and Date
                self.scannerState.asObservable(),
                self.productSubject.map({ $0?.gtin }).asObservable(),
                self.dateSubject.asObservable()
            )
            .filter({ $1 != nil && $2 != nil })                 //  if both are present
            .map({ ($0, $1!, $2!) })                            //  forced unwrap
            .filter({ self.validate(date: $2) == .success })    //  and date is valid
            .subscribe({ [weak self] next in
                
                //  unpack values an check if not allready processing
                guard let strong = self,
                    let (scannerState, productGTIN, date) = next.element,
                    scannerState != .processing
                    else { return }
                
                strong.scannerState.onNext(.processing)
                
                //  Create 'FoodItem'
                //  Wait 3 seconds before save and push item
                strong.startProgressIndicator(seconds: 3)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    let newItem = FoodItem(bestBeforeDate: date!, productGTIN: productGTIN)

                    guard var prevItems = try? strong.scannedItems.value()
                        else {
                            strong.scannerState.onNext(.ready)
                            return
                    }
                    
                    prevItems.append(newItem)
                    strong.scannedItems.onNext(prevItems)
                    strong.resetScanData()
                    
                    strong.scannerState.onNext(.ready)
                })
            })
            .disposed(by: disposeBag)
        
        
        Observable
            .combineLatest(dateSubject.asObservable(), dateRecognizer.stateObservable)
            .debug()
            .filter({
                switch $0.1 {
                case .result:
                    return false
                default: return $0.0 != nil
                }
            })
            .subscribe { [weak self] _ in
                log.debug("Pause recognizer due manuall date selection")
                self?.dateRecognizer.pause()
            }
            .disposed(by: disposeBag)
        
        dateRecognizer
            .stateObservable
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                switch state {
                case .ready: break
                case .result(let result):
                    strong.dateSubject.onNext(result)
                case .error(let error):
                    log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        gtinRecognizer
            .stateObservable
            .debug()
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                
                switch state {
                case .ready: break
                case .result(let result):
                    
                    if !(try! strong.isFetchingProductData.value()) {
                        strong.isFetchingProductData.onNext(true)
                        log.debug("Will get product data ...")
                        ProductManager.shared.getProductData(result, { (productResult) in
                            log.debug("Got result: \(productResult)")
                            switch productResult {
                            case .success(let product):
                                log.debug("Found product: \(product)")
                                strong.productSubject.onNext(product)
                                strong.isFetchingProductData.onNext(false)
                            case .failure(let error):
                                strong.message.onNext(Message(type: .error, title: "Database Error", text: error.localizedDescription))
                                strong.isFetchingProductData.onNext(false)
                            }
                        })
                    }
                    
                case .error(let error):
                    log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private var progressTimer: Timer?
    private func startProgressIndicator(seconds: Double) {
        resultShowProgressSubject.onNext(0.0)
        
        let fireDate = Date()
        progressTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(seconds / 100), repeats: true) { [weak self] (time) in
            let timeConsumed = Date().timeIntervalSince(fireDate) / seconds
            self?.resultShowProgressSubject.onNext(Float(timeConsumed))
            if timeConsumed >= 1.0 {
                self?.progressTimer?.invalidate()
                self?.resultShowProgressSubject.onNext(0.0)
            }
        }
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
    
    func toggleFlashlight() {
        guard let state = try? flashlightState.value() else { return }
        switch state {
        case .on, .dimmed(_):
            flashlightState.onNext(.off)
        case .off:
            flashlightState.onNext(.on)
        }
    }
    
    func resetScanData() {
        dateSubject.onNext(nil)
        productSubject.onNext(nil)
        dateRecognizer.reset()
        gtinRecognizer.reset()
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

