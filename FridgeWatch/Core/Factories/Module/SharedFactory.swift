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

    func makeItemDetailModule(viewModel: ItemDetail_ViewModelType, _ tableControllerHandler: @escaping (ItemDetail_TableView) -> Void) -> ItemDetail_View {
            
        let controller = R.storyboard.shared.itemDetailView()!
        controller.viewModel = viewModel
        controller.onTableViewSegue = { tableController in
            tableController.viewModel = viewModel
            tableControllerHandler(tableController)
        }
        return controller
    }
    
    func makeDatePickerModul(
        initialDate: Date?,
        onApply: @escaping (Date) -> Void,
        onClear: (() -> Void)?,
        onCancel: (() -> Void)?) -> UIAlertController
    {
        
        let datePicker = UIDatePicker(pickerMode: .date)
        datePicker.date = initialDate ?? Date()
        
        let todayButton = SyncButton(title: "Today", initialState: .standard) {
            datePicker.setDate(Date(), animated: true)
        }
        
        todayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        todayButton.translatesAutoresizingMaskIntoConstraints = false
        todayButton.setState(.standard)
        
        let stack = UIStackView(arrangedSubviews: [todayButton, datePicker])
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(stack)
        
        let margin: CGFloat = 10.0
        stack.frame = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 250)
        
        alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { _ in
            onApply(datePicker.date)
        }))
        
        if let onClear = onClear {
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
                onClear()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            onCancel?()            
        }))
        return alert
    }
    
    func makeConfirmDiscardScanResults(onReview: @escaping () -> Void, onDiscard: @escaping () -> Void, onCancel: @escaping () -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: "Unsaved Scan Results", message: "You have unsaved scan results. What would you like to do?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Review", style: .default, handler: { (_) in
            onReview()
        }))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (_) in
            onDiscard()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            onCancel()
        }))
        return alert
    }
    
    func makeConfirmMessage(
        title: String,
        message: String,
        _ completion: @escaping (Bool) -> Void) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
            completion(false)
        }))
        return alert
    }
    
    func makeGetAmountTextFieldModul(
        title: String,
        message: String,
        initialValue: Int?,
        onConfirm: @escaping (Int) -> Void) -> UIAlertController
    {
        let value = BehaviorSubject<Int>(value: 1)
        var disposeBag: DisposeBag? = DisposeBag()
        
        let alert = UIAlertController(title: nil, message: "\n\n", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
           
            textField.rx.text
                .filter({ $0 != nil })
                .map({ Int($0!) })
                .filter({ $0 != nil })
                .map({ $0! })
                .bind(to: value)
                .disposed(by: disposeBag!)
            
            if let initial = initialValue {
                textField.text = "\(initial)"
            }
            
            textField.becomeFirstResponder()
        }
    
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel(frame: .zero)
        messageLabel.text = message
        messageLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 6
        alert.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        alert.view.topAnchor.constraint(equalTo: stack.topAnchor, constant: -10).isActive = true
        alert.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 0).isActive = true
        alert.view.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 0).isActive = true
        
        
        //  Add Actions
        alert.addAction(UIAlertAction(title: "Apply", style: .destructive, handler: { _ in
            onConfirm(try! value.value())
            disposeBag = nil
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            disposeBag = nil
        }))
        return alert
    }
    
    func makeGetAmountSliderModul(
        title: String,
        message: String,
        maxAmount: Int,
        onConfirm: @escaping (Int) -> Void) -> UIAlertController
    {    
        let value = BehaviorSubject<Int>(value: 1)
        var disposeBag: DisposeBag? = DisposeBag()
        let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
    
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel(frame: .zero)
        messageLabel.text = message
        messageLabel.textAlignment = .center

        let valueLabel = UILabel(frame: .zero)
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.textAlignment = .center
        value.map({ "\($0)" }).bind(to: valueLabel.rx.text).disposed(by: disposeBag!)
        
        let slider = VSSlider(frame: .zero)
        slider.vertical = false
        slider.trackWidth = 8
        slider.markWidth = 3
        slider.minimumValue = 1
        slider.maximumValue = Float(maxAmount)
        slider.increment = 1
        slider.trackExtendsUnderThumb = false
        slider.rx.value.map({ Int($0) }).bind(to: value).disposed(by: disposeBag!)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, valueLabel, slider])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        alert.view.addSubview(stack)
        
        let margin: CGFloat = 10.0
        stack.frame = CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 180)
        alert.view.topAnchor.constraint(equalTo: stack.topAnchor, constant: -15).isActive = true
        alert.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -15).isActive = true
        alert.view.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 15).isActive = true
        
        alert.addAction(UIAlertAction(title: "Apply", style: .destructive, handler: { _ in
            onConfirm(Int(slider.value))
            disposeBag = nil
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            disposeBag = nil
        }))
        return alert
    }
        
    func makeImagePicker(
        sourceType: UIImagePickerController.SourceType,
        inlineDelegate: InlineImagePickerDelegate) -> UIImagePickerController
    {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType        
        controller.delegate = inlineDelegate
        return controller
    }
}

final class InlineImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var onApply: (UIImage) -> Void
    private var onCancel: () -> Void
        
    init(onApply: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
        self.onApply = onApply
        self.onCancel = onCancel
        super.init()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image: UIImage = info[.originalImage] as! UIImage
        onApply(image.reducedNormalized)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.onCancel()
    }
}

extension UIImage {
    var reducedNormalized: UIImage {
        
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.5);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}
