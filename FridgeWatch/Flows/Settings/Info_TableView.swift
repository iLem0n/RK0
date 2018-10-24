//
//  Info_TableView.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 20.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol Info_TableView: BaseViewType {
    var viewModel: Info_ViewModelType? { get set }
}
