//
//  SharedFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

extension ModuleFactory: SharedFactoryType {
    func makeDatePickerModul(
        viewModel: DatePickerViewModelType,
        onCompleted: @escaping () -> Void)
        -> UIAlertController {
            let datePicker = UIDatePicker(pickerMode: .date)
            
            if let date = try? viewModel.dateSubject.value() ?? Date() {
                datePicker.date = date
            }
            
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
                viewModel.dateSubject.onNext(datePicker.date)
                onCompleted()
            }))
            
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                viewModel.dateSubject.onNext(nil)
                onCompleted()
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in                
                onCompleted()
            }))
            return alert
    }
}

