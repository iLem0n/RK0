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
    
    lazy var date: Observable<Date?> = self.dateSubject.asObservable()
    private let dateSubject = BehaviorSubject<Date?>(value: nil)
    
    private lazy var combinedDataSubject = Observable
        .combineLatest(self.gtin, self.date)
    
    let scannedItems = BehaviorSubject<[FoodItem]>(value: [])
    
    private let scanEnabled = BehaviorSubject<Bool>(value: true)

    private let gtinRecognizer = BarcodeRecognizer()
    private let dateRecognizer = DateRecognizer()
    
    override init() {
        super.init()
        self.linkData()
        
    }
    
    private func linkData() {
        combinedDataSubject
            .debug()
            .subscribe { [weak self] next in
                guard let strong = self,
                    try! strong.scanEnabled.value(),
                    var prevItems = try? strong.scannedItems.value(),
                    let (nextGtin, nextDate) = next.element,
                    nextGtin != nil && nextDate != nil
                else { return }
                
                strong.scanEnabled.onNext(false)
                
                prevItems.append(FoodItem(gtin: nextGtin!, date: nextDate!))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    
                    strong.scannedItems.onNext(prevItems)
                    strong.gtinRecognizer.reset()
                    strong.dateRecognizer.reset()
                    strong.gtinSubject.onNext(nil)
                    strong.dateSubject.onNext(nil)
                    
                    strong.scanEnabled.onNext(true)
                })
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
                    self.dateSubject.onNext(result)
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
