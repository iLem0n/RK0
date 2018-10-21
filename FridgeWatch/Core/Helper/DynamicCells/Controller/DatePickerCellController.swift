//
//  DatePickerCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 20.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import RxSwift

final class DatePickerCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = DatePickerCellSetting
    private let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateLabel: UILabel!

    func configure(with setting: SettingType) {
        self.datePicker.datePickerMode = setting.pickerMode
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let date = setting.date {
            self.datePicker.date = date
        } else if let dynamicDate = setting.dynamicDate {
            dynamicDate
                .bind(to: datePicker.rx.date)
                .disposed(by: disposeBag)
            
            datePicker.rx.date
                .bind(to: dynamicDate)
                .disposed(by: disposeBag)
        }
        
        self.datePicker.rx.date
            .map({ DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: $0) })
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
