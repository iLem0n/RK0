//
//  SettingsCellType.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol DynamicCellType {
    associatedtype SettingType
    func configure(with setting: SettingType)
}
