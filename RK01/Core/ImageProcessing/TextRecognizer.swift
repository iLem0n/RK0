//
//  TextRecognizer.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 21.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation
import MicroBlink
import RxSwift

final class TextRecognizer: NSObject, RecognizerType {
    typealias ResultType = String
    
    lazy var stateObservable: Observable<RecognizerState<ResultType>> = self.stateSubject.asObservable()
    private let stateSubject = BehaviorSubject<RecognizerState<ResultType>>(value: .ready)
    
    private let runner: MBRecognizerRunner
    var rawParser: MBRawParser = {
        let parser = MBRawParser()
        let options = MBOcrEngineOptions()
        let digits = (48...57).map({ MBOcrCharKey(code: $0, font: .OCR_FONT_ANY) })
        let uppercaseLetters = (65...90).map({ MBOcrCharKey(code: $0, font: .OCR_FONT_ANY) })
        
        options.charWhitelist = Set(digits + uppercaseLetters)
        
        log.debug(options.charWhitelist)
        parser.ocrEngineOptions = options
        return parser
    }()
    
    private let recognizer: MBBlinkInputRecognizer
    private var isPaused: Bool = false
    
    override init() {
        
        self.recognizer = MBBlinkInputRecognizer(processors: [MBParserGroupProcessor(parsers: [rawParser])])
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
        stateSubject.onNext(.result(self.rawParser.result.rawText))
    }
}
