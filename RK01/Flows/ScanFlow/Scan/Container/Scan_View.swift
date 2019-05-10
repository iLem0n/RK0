//
//  Scan_View.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ScanView: BaseViewType {
    var viewModel: ScanViewModelType? { get set }
    var onCameraViewSegue: ((Scan_CameraView) -> Void)? { get set }
    
    var onSendButtonClicked: ((String) -> Void)? { get set }
}
