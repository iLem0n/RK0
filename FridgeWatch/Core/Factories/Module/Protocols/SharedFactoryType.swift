//
//  SharedFactoryType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

protocol SharedFactoryType {
    func makeItemDetailModule(
        viewModel: ItemDetail_ViewModelType,        
        _ tableControllerHandler: @escaping (ItemDetail_TableView) -> Void)
    -> ItemDetail_View?
    
    func makeConfirmMessage(title: String, message: String, _ completion: @escaping (Bool) -> Void) -> UIAlertController
    
    func makeDatePickerModul(
        viewModel: DatePickerViewModelType,
        onCompleted: @escaping () -> Void)
    -> UIAlertController
    
    func makeGetAmountModul(
        title: String,
        message: String,        
        maxItemsCount: Int,
        onCompleted: @escaping (Int) -> Void)
    -> UIAlertController
}
