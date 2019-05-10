//
//  StepperCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 31.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class ValueStepperCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    
    var title: String?
    var value: Double?
    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicValue: BehaviorSubject<Double>?
    var minValue: Double?
    var maxValue: Double?
    var stepValue: Double?
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         value: Double? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicValue: BehaviorSubject<Double>? = nil,
         minValue: Double? = 0.0,
         maxValue: Double? = 10.0,
         stepValue: Double? = 1.0) {
        self.identifier = identifier
        self.title = title
        self.value = value
        self.dynamicTitle = dynamicTitle
        self.dynamicValue = dynamicValue

        self.minValue = minValue
        self.maxValue = maxValue
        self.stepValue = stepValue
        
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
