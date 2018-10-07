//
//  FoodFactoryType.swift
//  FridgeWatch
//
//  Created by iLem0n on 03.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol FoodFactoryType {
    static func saveFoodItem(_ item: FoodItem) throws
}
