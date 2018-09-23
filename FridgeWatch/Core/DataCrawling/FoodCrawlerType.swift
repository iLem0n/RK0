//
//  FoodCrawlerType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 22.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Result

enum FoodCrawlerError: Error {
    case unknownProduct
}

protocol FoodCrawlerType {
    static var shared: FoodCrawlerType { get }
    
    func getProductData(_ gtin: String, _ resultHandler: (Result<Product, FoodCrawlerError>) -> Void)
    func updateProductData(_ gtin: String)
}
