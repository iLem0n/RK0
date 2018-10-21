//
//  SuggestionTextCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 02.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class SuggestionTextCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    typealias SuggestionsHandler = ((String, @escaping (([String]) -> Void)) -> Void)
    
    var title: String?
    var value: String?
    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicValue: BehaviorSubject<String>?
    var suggestionsHandler: SuggestionsHandler
    
    var keyboardType: UIKeyboardType = .default
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         value: String? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicValue: BehaviorSubject<String>? = nil,
         suggestionsHandler: @escaping SuggestionsHandler,
         keyboardType: UIKeyboardType = .default) {
        self.identifier = identifier
        self.title = title
        self.value = value
        self.dynamicTitle = dynamicTitle
        self.dynamicValue = dynamicValue
        self.keyboardType = keyboardType
        self.suggestionsHandler = suggestionsHandler
        
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
