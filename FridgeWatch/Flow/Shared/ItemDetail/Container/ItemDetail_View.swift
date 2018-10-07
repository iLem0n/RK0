//
//  ItemDetail_View.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ItemDetail_View: BaseViewType {
    var viewModel: ItemDetail_ViewModelType? { get set }
    var onTableViewSegue: ((ItemDetail_TableView) -> Void)? { get set }
}
