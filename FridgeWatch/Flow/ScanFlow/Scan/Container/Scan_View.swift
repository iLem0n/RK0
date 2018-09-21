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

protocol Scan_View: BaseViewType {
    var viewModel: Scan_ViewModelType? { get set }
    var onCameraViewSegue: ((Scan_CameraView) -> Void)? { get set }
    
    var onCloseButtonTouched: (() -> Void)? { get set }
    var onResultsListButtonTouched: (() -> Void)? { get set }

}
