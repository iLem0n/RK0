//
//  DatePickerView.swift
//
//  FoodWatch
//
//  Created by Peter Christian Glade on 28.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol DatePickerView: BaseViewType {
    var viewModel: DatePickerViewModelType? { get set }
    var onSaveButtonTouched: (() -> Void)? { get set }
    var onResetButtonTouched: (() -> Void)? { get set }
}
