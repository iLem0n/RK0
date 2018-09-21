//
//  StorageContent_TableView.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol StorageContent_TableView: BaseViewType {
    var viewModel: StorageContent_ViewModelType? { get set }
}
