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
import SwipeCellKit

protocol StorageContent_TableView: BaseViewType, SwipeTableViewCellDelegate {
    var viewModel: StorageContent_ViewModelType? { get set }
}
