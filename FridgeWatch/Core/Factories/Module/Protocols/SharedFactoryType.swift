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
    -> ItemDetail_View
    
    func makeConfirmMessage(
        title: String,
        message: String,
        _ completion: @escaping (Bool) -> Void)
    -> UIAlertController
    
    func makeConfirmDiscardScanResults(
        onReview: @escaping () -> Void,
        onDiscard: @escaping () -> Void,
        onCancel: @escaping () -> Void)
    -> UIAlertController

    func makeDatePickerModul(
        initialDate: Date?,
        onApply: @escaping (Date) -> Void,
        onClear: (() -> Void)?,
        onCancel: @escaping () -> Void)
    -> UIAlertController
    
    func makeGetAmountSliderModul(
        title: String,
        message: String,
        maxAmount: Int,
        onConfirm: @escaping (Int) -> Void)
        -> UIAlertController        

    func makeGetAmountTextFieldModul(
        title: String,
        message: String,
        initialValue: Int?,
        onConfirm: @escaping (Int) -> Void)
    -> UIAlertController
    
    func makeImagePicker(
        sourceType: UIImagePickerController.SourceType,
        inlineDelegate: InlineImagePickerDelegate)
    -> UIImagePickerController
}
