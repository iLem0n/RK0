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
    var cameraAvailable: BehaviorSubject<Bool> { get }
    var isCapturing: BehaviorSubject<Bool> { get }
    var isFlashlightOn: BehaviorSubject<Bool> { get }
    
    var gtin: Observable<String?> { get }
    var productName: Observable<String?> { get }
    
    var date: BehaviorSubject<Date?> { get }
    var dateViewState: Observable<ViewState> { get }
    
    var scannedItems: BehaviorSubject<[FoodItem]> { get }
}
