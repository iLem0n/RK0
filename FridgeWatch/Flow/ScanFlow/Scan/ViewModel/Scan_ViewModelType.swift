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

protocol Scan_ViewModelType: ViewModelType, AVCaptureVideoDataOutputSampleBufferDelegate {
    var scanDataState: Observable<ScanDataState> { get }
    
    var scannedItemsSubject: BehaviorSubject<[FoodItem]> { get }
    var amountSubject: BehaviorSubject<Int> { get }
    var dateSubject: BehaviorSubject<Date?> { get }
    var roiSubject: BehaviorSubject<CGRect> { get }
    var productObservable: Observable<Product?> { get }
    
    var flashlightStateObservable: Observable<FlashlightState> { get }
    var scannerStateSubject: BehaviorSubject<ScannerState> { get }
    
    var productValidationStateObservable: Observable<ValidationState> { get }
    var dateValidationStateObservable: Observable<ValidationState> { get }
    
    func toggleFlashlight()
    
    func addItemToList()
    func resetScanData()    
}
