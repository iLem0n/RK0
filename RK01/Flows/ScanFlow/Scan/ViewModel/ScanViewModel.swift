//
//  ScanViewModel.swift
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

final class ScanViewModel: NSObject, ScanViewModelType {
    //------------ COMMON -----------------
    let message = PublishSubject<Message>()
    private let disposeBag = DisposeBag()
    
    //------------ STATUS -----------------
    let scannerStateSubject = BehaviorSubject<ScannerState>(value: .tearUp)
    private let flashlightStateSubject = BehaviorSubject<FlashlightState>(value: .off)
    private let isFetchingProductDataSubject = BehaviorSubject<Bool>(value: false)
    
    //------------ STATUS OBSERVABLES ------------
    lazy var flashlightStateObservable = self.flashlightStateSubject.asObservable()

    //------------ DATA --------------------
    let textSubject = BehaviorSubject<String?>(value: nil)
    let roiSubject = BehaviorSubject<CGRect>(value: .one)
    
    //------------ DATA OBSERVABLES ------------
    
    
    //------------ WORKER -------------------
    internal let textRecognizer = TextRecognizer()
    
    //------------ LIFECYCLE ------------
    override init() {
        super.init()
        self.resetScanData()
        self.linkScanData()
    }
    
    private func linkScanData() {
        //  Check Text recognizer state
        textRecognizer
            .stateObservable
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                switch state {
                case .ready: break
                case .result(let result):
                    log.debug(result)
                    strong.textSubject.onNext(result)
                    strong.textRecognizer.pause()
                case .error(let error):
                    strong.message.onNext(Message(type: .error, title: "Text Recognizer Error", message: error.localizedDescription))
                }
            }
            .disposed(by: disposeBag)
        
        //  Pseudo data in simulator
        if Platform.isSimulator { setPseudoData() }
    }
    
    private func setPseudoData() {
        textSubject.onNext("PUKCOM321")
    }
    
   
    
    private var productUpdateToken: NotificationToken?
    private func handleGTINResult(_ result: String) {
        guard let isFetching = try? isFetchingProductDataSubject.value() else { return }
        
        if !isFetching {
            isFetchingProductDataSubject.onNext(true)
    
        }
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
        textSubject.onNext(nil)
        textRecognizer.reset()
        
        scannerStateSubject.onNext(.ready)
    }
}



