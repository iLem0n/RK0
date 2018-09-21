//
//  ImageProcessor.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift
import MicroBlink

final class ImageProcessingOperation: Operation, MBScanningRecognizerRunnerDelegate {
    private let originalImage: UIImage
    private let recognizer: MBBlinkInputRecognizer
    private let recognizerRunner: MBRecognizerRunner
    private let recognizerCollection: MBRecognizerCollection
    
    init(image: UIImage) {
        self.originalImage = image
        self.recognizer = MBBlinkInputRecognizer()
        self.recognizerCollection = MBRecognizerCollection(recognizers: [recognizer])
        self.recognizerRunner = MBRecognizerRunner(recognizerCollection: recognizerCollection)
        
        super.init()
        self.recognizerRunner.scanningRecognizerRunnerDelegate = self
    }
    
    func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
        log.debug(#function)
        if recognizer.result.resultState == MBRecognizerResultState.valid {
            log.debug("Result: \(recognizer.result as MBBlinkInputRecognizerResult)")
        }
    }
    
    override func start() {
        guard !self.isCancelled else { return }
        let image = MBImage(uiImage: originalImage)
        
        image.cameraFrame = true
        image.orientation = MBProcessingOrientation.left
        
        guard !self.isCancelled else { return }
        log.debug("Process image ...")
        self.recognizerRunner.processImage(image)
        
    }
}
