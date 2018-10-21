//
//  Settings_TableView.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol Settings_TableView: BaseViewType {
    var viewModel: Settings_ViewModelType? { get set }
    
    var onFeedbackCellClicked: (() -> Void)? { get set }
    var onInfoCellClicked: (() -> Void)? { get set }
}
