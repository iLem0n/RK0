//
//  SharedFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

extension ModuleFactory: SharedFactoryType {
    
    func makeItemDetailModule(
        viewModel: ItemDetail_ViewModelType,
        _ tableControllerHandler: @escaping (ItemDetail_TableView) -> Void)
    -> ItemDetail_View? {
        let controller = R.storyboard.shared.itemDetailView()!
        controller.viewModel = viewModel
        controller.onTableViewSegue = { tableController in
            tableController.viewModel = viewModel
            tableControllerHandler(tableController)
        }
        return controller
    }
    
    func makeDatePickerModul(
        viewModel: DatePickerViewModelType,
        onCompleted: @escaping () -> Void)
        -> UIAlertController {
            let datePicker = UIDatePicker(pickerMode: .date)
            datePicker.date = viewModel.pickerInitialDate ?? Date()
            
            let todayButton = SyncButton(title: "Today", initialState: .standard) {
                datePicker.setDate(Date(), animated: true)
            }
            
            todayButton.frame.size.height = 30
            todayButton.setState(.standard)
            
            let stack = UIStackView(arrangedSubviews: [todayButton, datePicker])
            stack.alignment = .fill
            stack.distribution = .fill
            stack.axis = .vertical
            
            let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            alert.view.addSubview(stack)
            
            let margin: CGFloat = 10.0
            stack.frame = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 180)
            
            alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { _ in
                viewModel.onDatePicked?(datePicker.date)
                onCompleted()
            }))
            
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                viewModel.onDatePicked?(nil)
                onCompleted()
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in                
                onCompleted()
            }))
            return alert
    }
    
    func makeConfirmMessage(title: String, message: String, _ completion: @escaping (Bool) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            completion(false)
        }))
        return alert
    }
    
    func makeGetAmountModul(
        title: String,
        message: String,
        maxItemsCount: Int,
        onCompleted: @escaping (Int) -> Void)
        -> UIAlertController {
            let titleLabel = UILabel(frame: .zero)
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            titleLabel.textAlignment = .center
            
            let messageLabel = UILabel(frame: .zero)
            messageLabel.text = message
            messageLabel.textAlignment = .center
            
            let value = BehaviorSubject<Int>(value: 1)
            var disposeBag: DisposeBag? = DisposeBag()
            
            let valueLabel = UILabel(frame: .zero)
            valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
            valueLabel.textAlignment = .center
            value.map({ "\($0)" }).bind(to: valueLabel.rx.text).disposed(by: disposeBag!)

            let slider = VSSlider(frame: .zero)
            slider.vertical = false
            slider.trackWidth = 8
            slider.markWidth = 3
            slider.minimumValue = 1
            slider.maximumValue = Float(maxItemsCount)
            slider.increment = 1
            slider.rx.value.map({ Int($0) }).bind(to: value).disposed(by: disposeBag!)
            
            let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, valueLabel, slider])
            stack.alignment = .fill
            stack.distribution = .fillEqually
            stack.axis = .vertical
            stack.spacing = 6
            
            let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            alert.view.addSubview(stack)
            
            let margin: CGFloat = 10.0
            stack.frame = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 180)
            
            alert.addAction(UIAlertAction(title: "Apply", style: .destructive, handler: { _ in
                onCompleted(try! value.value())
                disposeBag = nil
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                onCompleted(0)
                disposeBag = nil
            }))
            return alert
    }
}

