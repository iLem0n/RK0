//
//  TextCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 31.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class TextCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    var title: String?
    var value: String?
    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicValue: BehaviorSubject<String>?
    
    var keyboardType: UIKeyboardType = .default
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         value: String? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicValue: BehaviorSubject<String>? = nil,
         keyboardType: UIKeyboardType = .default) {
        self.identifier = identifier
        self.title = title
        self.value = value
        self.dynamicTitle = dynamicTitle
        self.dynamicValue = dynamicValue
        self.keyboardType = keyboardType
     
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if value != nil && dynamicValue != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
