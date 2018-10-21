//
//  DetailedCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 31.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class DetailedCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    let id: UUID = UUID()
    var title: String?
    var subtitle: String?
    weak var dynamicTitle: Observable<String>?
    weak var dynamicSubtitle: Observable<String>?
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         subtitle: String? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicSubtitle: BehaviorSubject<String>? = nil) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.dynamicTitle = dynamicTitle
        self.dynamicSubtitle = dynamicSubtitle
        
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if subtitle != nil && dynamicSubtitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
