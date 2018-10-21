//
//  DatePickerCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 20.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class DatePickerCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    var title: String?
    var date: Date?
    var pickerMode: UIDatePicker.Mode

    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicDate: BehaviorSubject<Date>?
    
    init(identifier: DynamicCellSettingIdentifier,
         pickerMode: UIDatePicker.Mode = .date,
         title: String? = nil,
         date: Date? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicDate: BehaviorSubject<Date>? = nil) {
        self.identifier = identifier
        self.pickerMode = pickerMode
        self.title = title
        self.date = date
        self.dynamicTitle = dynamicTitle
        self.dynamicDate = dynamicDate
                
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if date != nil && dynamicDate != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
