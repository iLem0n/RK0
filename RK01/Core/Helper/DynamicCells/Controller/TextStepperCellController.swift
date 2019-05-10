//
//  TextStepperCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 12.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class TextStepperCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = TextStepperCellSetting
    private let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var stepper: TextStepper!
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.stepper.isEnabled = editing
    }
    
    func configure(with setting: SettingType) {
        self.titleLabel.text = setting.title
        
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let index = setting.index {
            self.stepper.selectedIndex = index
            self.stepper.rx.index
                .map({ String(format: "%.0f", $0) })
                .bind(to: valueLabel.rx.text)
                .disposed(by: disposeBag)
        } else if let dynamicIndex = setting.dynamicIndex {
            dynamicIndex
                .bind(to: stepper.rx.index)
                .disposed(by: disposeBag)
            dynamicIndex
                .map({ String(format: "%.0f", $0) })
                .bind(to: valueLabel.rx.text)
                .disposed(by: disposeBag)
            
            stepper.rx.index
                .bind(to: dynamicIndex)
                .disposed(by: disposeBag)
        }
        
    }
}
