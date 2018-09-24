//
//  FoodFactoryType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Result

protocol FoodFactoryType {
    static func makeProduct(_ gtin: String, _ completion: @escaping (Result<Product, FoodCrawlerError>) -> Void)
    static func prepareFoodItem(productID: String, bestBeforeDate: Date, _ completion: @escaping (Result<FoodItem, FoodFactoryError>) -> Void)
}
