//
//  ValueStepperCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class ValueStepperCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = ValueStepperCellSetting
    private let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var stepper: ValueStepper!

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.stepper.isEnabled = editing
    }

    func configure(with setting: SettingType) {
        self.titleLabel.text = setting.title
        stepper.minimumValue = setting.minValue ?? 0
        stepper.maximumValue = setting.maxValue ?? 10
        stepper.stepValue = setting.stepValue ?? 1
        
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let value = setting.value {
            self.stepper.value = value
            self.stepper.rx.value
                .debug()
                .map({ String(format: "%.0f", $0) })
                .bind(to: valueLabel.rx.text)
                .disposed(by: disposeBag)
        } else if let dynamicValue = setting.dynamicValue {
            dynamicValue
                .debug()
                .bind(to: stepper.rx.value)
                .disposed(by: disposeBag)
            dynamicValue
                .debug()
                .map({ String(format: "%.0f", $0) })
                .bind(to: valueLabel.rx.text)
                .disposed(by: disposeBag)
            
            stepper.rx.value
                .bind(to: dynamicValue)
                .disposed(by: disposeBag)
        }
        
    }
}
