//
//  ScanViewModel+CaptureDelegate.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation

extension ScanViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let roi: CGRect
        if let roiValue = try? self.roiSubject.value() {
            roi = roiValue
        } else {
            roi = .one
        }
        
        switch textRecognizer.state {
        case .ready:
            self.textRecognizer.process(sampleBuffer, roi: roi)
        default: break
        }
            
    }
}
