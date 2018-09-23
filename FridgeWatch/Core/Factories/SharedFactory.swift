//
//  SharedFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

extension ModuleFactory: SharedFactoryType {
    func makeDatePickerModul(date: Date = Date(), onApply: @escaping (Date) -> Void, onClear: (() -> Void)? = nil, onCancel: @escaping () -> Void) -> UIAlertController {
        let datePicker = UIDatePicker(pickerMode: .date)
        datePicker.date = date
        
        let todayButton = SyncButton(title: "Today", initialState: .standard) {
            datePicker.setDate(Date(), animated: true)
        }
        todayButton.frame.size.height = 30
        
        let stack = UIStackView(arrangedSubviews: [todayButton, datePicker])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(stack)
        
        let margin: CGFloat = 10.0
        stack.frame = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 180)
        
        alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { _ in
            onApply(datePicker.date)
        }))
        
        if let onClear = onClear {
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                onClear()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            onCancel()
        }))
        return alert
    }
}
