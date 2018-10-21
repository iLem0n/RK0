//
//  Settings_View.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol Settings_View: BaseViewType {
    var viewModel: Settings_ViewModelType? { get set }
    var onTableViewSegue: ((Settings_TableView) -> Void)? { get set }
}
