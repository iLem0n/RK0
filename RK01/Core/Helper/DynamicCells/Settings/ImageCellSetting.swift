//
//  ImageCellSetting.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 06.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

final class ImageCellSetting: DynamicCellSettingType {
    let identifier: DynamicCellSettingIdentifier
    
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    weak var dynamicTitle: BehaviorSubject<String>?
    weak var dynamicSubtitle: BehaviorSubject<String>?
    weak var dynamicImage: BehaviorSubject<UIImage>?
    
    init(identifier: DynamicCellSettingIdentifier,
         title: String? = nil,
         subtitle: String? = nil,
         image: UIImage? = nil,
         dynamicTitle: BehaviorSubject<String>? = nil,
         dynamicSubtitle: BehaviorSubject<String>? = nil,
         dynamicImage: BehaviorSubject<UIImage>? = nil) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.dynamicTitle = dynamicTitle
        self.dynamicSubtitle = dynamicSubtitle
        self.dynamicImage = dynamicImage
        
        checkAmbiguity()
    }
    
    private func checkAmbiguity() {
        if title != nil && dynamicTitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if subtitle != nil && dynamicSubtitle != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
        
        if image != nil && dynamicImage != nil {
            log.warning("Ambigous cell settings data: \(self)")
        }
    }
}
