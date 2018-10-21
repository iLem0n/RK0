//
//  DefaultCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 31.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class DefaultCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    var title: String?
    weak var dynamicTitle: BehaviorSubject<String>?
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil) {
        self.identifier = identifier
        self.title = title
        self.dynamicTitle = dynamicTitle
        
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
