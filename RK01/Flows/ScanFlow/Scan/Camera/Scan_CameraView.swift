//
//  Scan_CameraView.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol Scan_CameraView: BaseViewType {
    var viewModel: ScanViewModelType? { get set }
}
