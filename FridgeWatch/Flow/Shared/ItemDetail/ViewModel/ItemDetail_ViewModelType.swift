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
 
    var productName: Observable<String> { get }
    var productImage: Observable<UIImage?> { get }
    var bestBeforeDate: Observable<Date> { get }
    var remainingDays: Observable<Int> { get }
    var availableAmount: Observable<Int> { get }
    
    
    init(item: FoodItem)
    
    func updateAmount(_ amount: Int)
    func updateDate(_ date: Date)
    func updateProductImage(_ image: UIImage)
}
