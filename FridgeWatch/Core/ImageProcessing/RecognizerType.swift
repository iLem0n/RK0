//
//  RecognizerType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 21.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import AVFoundation
import MicroBlink
import RxSwift

enum RecognizerState<ResultType> {
    case ready    
    case result(ResultType)
    case error(Error)
}

protocol RecognizerType: MBScanningRecognizerRunnerDelegate {
    associatedtype ResultType
    
    var stateObservable: Observable<RecognizerState<ResultType>>  { get }
    var state: RecognizerState<ResultType> { get }
    
    func process(_ sampleBuffer: CMSampleBuffer, roi: CGRect)
    func reset()
    func pause()
}
