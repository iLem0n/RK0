//
//  DateRecognizer.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 21.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation
import MicroBlink
import RxSwift

final class DateRecognizer: NSObject, RecognizerType {
    typealias ResultType = Date
    typealias DateValidatorType = (Date) -> Bool
    
    lazy var stateObservable: Observable<RecognizerState<ResultType>> = self.stateSubject.asObservable()
    private let stateSubject = BehaviorSubject<RecognizerState<ResultType>>(value: .ready)
    
    private let runner: MBRecognizerRunner
    private let recognizer: MBBlinkInputRecognizer
    private let parsers: [MBParser]
    private var isPaused: Bool = false
    private var validator: DateValidatorType?
    
    init(validator: DateValidatorType? = nil) {
        self.validator = validator
        self.parsers = [MBRawParser()]
        self.recognizer = MBBlinkInputRecognizer(
            processors: [
                MBParserGroupProcessor(parsers: self.parsers)
            ]
        )
        
        self.runner = MBRecognizerRunner(recognizerCollection: MBRecognizerCollection(recognizers: [self.recognizer]))
        
        super.init()
        
        self.runner.scanningRecognizerRunnerDelegate = self
    }
    
    var state: RecognizerState<ResultType> {
        guard let state = try? self.stateSubject.value() else { fatalError("State not initilized.") }
        return state
    }
    
    func process(_ sampleBuffer: CMSampleBuffer, roi: CGRect) {
        guard !self.isPaused else { return }
        let image = MBImage(cmSampleBuffer: sampleBuffer)
        image.roi = CGRect(x: roi.minY, y: roi.minX, width: roi.height, height: roi.width)
        image.orientation = MBProcessingOrientation.left
        self.runner.processImage(image)
    }
    
    func pause() {
        self.isPaused = true
    }
    
    func reset() {
        self.runner.resetState()
        self.stateSubject.onNext(.ready)
        self.isPaused = false
    }
    
    func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
        guard state == .valid else { return }
        checkResult()
    }
    
    private func checkResult() {
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
        for parser in parsers {
            switch parser {
            case let p as MBDateParser:
                stateSubject.onNext(.result(p.result.date.date))
            case let p as MBRawParser:
                guard let date = self.extractDate(from: p.result.rawText) else { return }
                stateSubject.onNext(.result(date))
            default: break
            }
        }
    }
    
    private func extractDate(from source: String) -> Date? {
        let seperators = [",", ".", " ", "\\/", "-"]
        let expressions: [DateRegex] = [
            DateRegex(pattern: "([0-9]{1,2} ?\\S ?)?[0-9]{1,2} ?\\S ?[0-9]{2,4}",
                      templates: ["dd<s>MM<s>yyyy", "dd<s>MM<s>yy", "MM<s>yyyy", "MM<s>yy", "ddMMyy", "ddMMyyyy"],
                      token: "<s>",
                      seperators: seperators,
                      masks: [" "])
        ]
        
        for regex in expressions {
            guard
                let date = regex.evaluate(source),
                self.validator?(date) ?? true
            else { return nil }
            
            return date
        }
        return nil
    }
}
