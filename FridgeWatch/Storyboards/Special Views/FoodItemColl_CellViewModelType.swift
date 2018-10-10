//
//  FoodItemColl_CellViewModelType.swift
//  FridgeWatch
//
//  Created by iLem0n on 08.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol FoodItemColl_CellViewModelType {
    var editingModeObservable: Observable<BulkEditingMode> { get }

    var amount: Observable<Int> { get }
    var bestBeforeDate: Observable<Date> { get }
    var productName: Observable<String> { get }
    var productImage: Observable<UIImage> { get }
    var editedAmount: BehaviorSubject<Int> { get }

    init(item: FoodItem, editingModeObservable: Observable<BulkEditingMode>, onAmountEditing: @escaping (Int) -> Void)
    func selectAllToEdit()
}
