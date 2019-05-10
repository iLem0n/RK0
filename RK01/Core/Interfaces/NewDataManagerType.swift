//
//  NewDataManagerType.swift
//  FridgeWatch
//
//  Created by iLem0n on 13.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//
//
//import Foundation
//import RealmSwift
//import Result
//
//enum DataManagerError: Error {
//    case realmError(Error)
//}
//
//
//protocol NewDataManagerType {
//    static var shared: NewDataManagerType { get }
//    
//    var foodItemStore: FoodItemStore { get }
//    var productStore: ProductStore { get }
//        
//    func foodItems() -> Results<FoodItem>
//    func foodItem(_ primaryKey: String) -> FoodItem?
//    func product(forGTIN gtin: String, _ resultHandler: @escaping (Result<Product, NewDataManagerError>) -> Void)
//    func product(forItemWithID itemID: String, _ resultHandler: @escaping (Result<Product, NewDataManagerError>) -> Void)
//    func updateFoodItem(_ primaryKey: String, updateHandler: (FoodItem) -> Void, errorHandler: (NewDataManagerError) -> Void)
//}
