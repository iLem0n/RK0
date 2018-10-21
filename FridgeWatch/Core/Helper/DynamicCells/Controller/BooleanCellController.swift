//
//  BooleanCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class BooleanCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = BooleanCellSetting
    private var disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var switchControl: UISwitch!
    
    func configure(with setting: SettingType) {
        self.selectionStyle = .none
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let value = setting.value {
            self.switchControl.isOn = value
        } else if let dynamicValue = setting.dynamicValue {
            dynamicValue
                .bind(to: switchControl.rx.isOn)
                .disposed(by: disposeBag)
            
            switchControl.rx.isOn
                .bind(to: dynamicValue)
                .disposed(by: disposeBag)
        }
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
        super.prepareForReuse()
    }
}
