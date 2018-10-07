//
//  ScanResults_TableView.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ScanResults_TableView: BaseViewType {
    var viewModel: ScanResults_ViewModelType? { get set }
    var onItemSelected: ((IndexPath) -> Void)? { get set }
}
