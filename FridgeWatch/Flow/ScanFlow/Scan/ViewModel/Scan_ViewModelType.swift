//
//  Scan_ViewModelType.swift
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

protocol Scan_ViewModelType: ViewModelType, DatePickerViewModelType, AVCaptureVideoDataOutputSampleBufferDelegate {
    var scannerState: BehaviorSubject<ScannerState> { get }
    var flashlightState: BehaviorSubject<FlashlightState> { get }
    
    var resultShowProgress: Observable<Float> { get }
    
    var dateSubject: BehaviorSubject<Date?> { get }
    var product: Observable<Product?> { get }
    
    var scannedItems: BehaviorSubject<[FoodItem]> { get }
    
    var productValidationState: Observable<ValidationState> { get }
    var dateValidationState: Observable<ValidationState> { get }
    
    func toggleFlashlight()
    func resetScanData()
}
