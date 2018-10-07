//
//  Scan_ViewModel+CaptureDelegate.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation

extension Scan_ViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
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
