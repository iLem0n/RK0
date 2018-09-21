//
//  BarcodeRecognizer.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 21.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation
import MicroBlink
import RxSwift

final class BarcodeRecognizer: NSObject, RecognizerType {
    typealias ResultType = String
    
    lazy var stateObservable: Observable<RecognizerState<ResultType>> = self.stateSubject.asObservable()
    private let stateSubject = BehaviorSubject<RecognizerState<ResultType>>(value: .ready)
    
    private let runner: MBRecognizerRunner
    private let recognizer: MBBarcodeRecognizer
    
    override init() {
        self.recognizer = MBBarcodeRecognizer()
        self.recognizer.scanEAN13 = true
        self.recognizer.scanEAN8 = true
        self.recognizer.scanInverse = true

        self.runner = MBRecognizerRunner(recognizerCollection: MBRecognizerCollection(recognizers: [self.recognizer]))
        
        super.init()
        
        self.runner.scanningRecognizerRunnerDelegate = self
    }
    
    var state: RecognizerState<ResultType> {
        guard let state = try? self.stateSubject.value() else { fatalError("State not initilized.") }
        return state
    }
    
    func process(_ sampleBuffer: CMSampleBuffer) {
        let image = MBImage(cmSampleBuffer: sampleBuffer)
        image.orientation = MBProcessingOrientation.left
        self.runner.processImage(image)
    }
    
    func reset() {
//        self.runner.cancelProcessing()
        self.runner.resetState()
        self.stateSubject.onNext(.ready)
    }
    
    func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
        guard state == .valid else { return }
        testResult()
    }
    
    private func testResult() {
        switch state {
        case .ready:            
            DispatchQueue.main.async { [weak self] in
                guard let strong = self, strong.recognizer.result.resultState == .valid else { return }
                strong.parseResult()
            }
        default: break
        }
    }
    
    private func parseResult() {
        stateSubject.onNext(.result(recognizer.result.stringData()))        
    }
}
