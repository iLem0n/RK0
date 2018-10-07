//
//  ItemDetail_TableView.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ItemDetail_TableView: BaseViewType {
    var viewModel: ItemDetail_ViewModelType? { get set }
    
    var onAmountCellTouched: (() -> Void)? { get set }
    var onDateCellTouched: (() -> Void)? { get set }
    var onImageViewTouched: (() -> Void)? { get set }
}
