//
//  StorageContentView.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol StorageContentView: PresentableType {
    var viewModel: StorageContentViewModelType? { get set }
}
