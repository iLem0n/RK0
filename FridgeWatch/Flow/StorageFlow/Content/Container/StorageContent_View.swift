//
//  StorageContent_View.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol StorageContent_View: BaseViewType {
    var viewModel: StorageContent_ViewModelType? { get set }
    var onCollectionViewSegue: ((StorageContent_CollectionView) -> Void)? { get set }
    
    var onStartScanButtonTouched: (() -> Void)? { get set }
    var onSettingsButtonTouched: (() -> Void)? { get set }
}
