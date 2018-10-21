//
//  SuggestionTextCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 02.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class SuggestionTextCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = SuggestionTextCellSetting
    private let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: RxSuggestionTextField!
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.isUserInteractionEnabled = editing
        self.textField.borderStyle = editing ? .roundedRect : .none
    }
    
    func configure(with setting: SettingType) {
        self.textField.suggestionsHandler = setting.suggestionsHandler
        textField.keyboardType = setting.keyboardType
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let value = setting.value {
            self.titleLabel.text = value
        } else if let dynamicValue = setting.dynamicValue {
            dynamicValue
                .bind(to: textField.rx.text)
                .disposed(by: disposeBag)
            
            textField.rx.text
                .filter({ $0 != nil }).map({ $0! })
                .bind(to: dynamicValue)
                .disposed(by: disposeBag)

        }
    }
}
