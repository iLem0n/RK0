//
//  ScanResults_View.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ScanResults_View: BaseViewType {
    var viewModel: ScanResults_ViewModelType? { get set }
    var onTableViewSegue: ((ScanResults_TableView) -> Void)? { get set }
}
