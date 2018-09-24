//
//  FoodFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Result

enum FoodFactoryError: Error {
    case unableToCreateProduct(Error)
}

final class FoodFactory: FoodFactoryType {
    public static func makeProduct(_ gtin: String, _ completion: @escaping (Result<Product, FoodCrawlerError>) -> Void) {
        let realm = Realms.local
        if let existing = realm.object(ofType: Product.self, forPrimaryKey: gtin) {
            ProductCrawler.shared.getProductData(gtin, completion)
            return
        }
        
        let product = Product(gtin: gtin)
        try? realm.write {
            realm.add(product)
        }
        ProductCrawler.shared.getProductData(gtin, completion)
    }
    
    public static func prepareFoodItem(productID: String, bestBeforeDate: Date, _ completion: @escaping (Result<FoodItem, FoodFactoryError>) -> Void) {
        makeProduct(productID) { (result) in
            switch result {
            case .success(let product):
                completion(.success(FoodItem(bestBeforeDate: bestBeforeDate, product: product)))
            case .failure(let error):
                completion(.failure(.unableToCreateProduct(error)))
            }
        }
    }
}
