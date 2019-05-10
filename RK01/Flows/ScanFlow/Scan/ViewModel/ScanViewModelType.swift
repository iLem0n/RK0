//
//  ScanViewModelType.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources
import AVFoundation
import MicroBlink

protocol ScanViewModelType: ViewModelType, AVCaptureVideoDataOutputSampleBufferDelegate {    
    var textSubject: BehaviorSubject<String?> { get }
    var roiSubject: BehaviorSubject<CGRect> { get }
    
    var flashlightStateObservable: Observable<FlashlightState> { get }
    var scannerStateSubject: BehaviorSubject<ScannerState> { get }
    
    func toggleFlashlight()

    func resetScanData()    
}
