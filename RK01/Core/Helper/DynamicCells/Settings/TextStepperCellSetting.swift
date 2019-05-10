//
//  TextStepperCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 12.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class TextStepperCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    var title: String?
    var values: [String]
    var index: Int?
    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicIndex: BehaviorSubject<Int>?
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         values: [String],
         index: Int? = 0,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicIndex: BehaviorSubject<Int>? = nil) {
        self.identifier = identifier
        self.title = title
        self.values = values
        self.index = index
        self.dynamicTitle = dynamicTitle
        self.dynamicIndex = dynamicIndex
                
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if index != nil && dynamicIndex != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
