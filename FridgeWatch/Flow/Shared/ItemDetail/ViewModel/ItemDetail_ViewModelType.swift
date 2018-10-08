//
//  ItemDetail_ViewModelType.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

protocol ItemDetail_ViewModelType: ViewModelType {
    var disposeBag: DisposeBag { get }
    var item: Observable<FoodItem> { get }
    init(item: FoodItem)
    
    func updateAmount(_ amount: Int)
    func updateDate(_ date: Date)
}
