//
//  DatePickerController.swift
//
//  FoodWatch
//
//  Created by Peter Christian Glade on 28.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

final class DatePickerController: UIViewController, DatePickerView {
    
    var viewModel: DatePickerViewModelType?
    let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var selectButton: UIButton!
    
    var onResetButtonTouched: (() -> Void)?
    var onSaveButtonTouched: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        resetButton.setState(.standard)
        selectButton.setState(.standard)
        
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.dateSubject
            .filter({ $0 != nil }).map({ $0! })
            .bind(to: datePicker.rx.date)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: viewModel.dateSubject)
            .disposed(by: disposeBag)
        
        selectButton
            .rx.tap
            .subscribe { [weak self] _ in
                guard let strong = self else { return }
                strong.onSaveButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        resetButton
            .rx.tap
            .subscribe { [weak self] _ in
                guard let strong = self else { return }
                strong.onResetButtonTouched?()
            }
            .disposed(by: disposeBag)
    }
}
