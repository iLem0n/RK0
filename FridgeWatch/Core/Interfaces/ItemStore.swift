//
//  ItemStore.swift
//  FridgeWatch
//
//  Created by iLem0n on 16.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import Result

class ItemStore: NSObject {
    static let shared = ItemStore()
    
    private func getRealm(_ completion: (Result<Realm, StoreError>) -> Void) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true, objectTypes: [FoodItem.self])
            let realm = try Realm(configuration: config)
            completion(.success(realm))
        } catch (let error) {
            completion(.failure(.realmError(error)))
        }
    }
    
    func save(_ item: FoodItem, _ completion: ((Result<Void, StoreError>) -> Void)? = nil) {
        getRealm {
            switch $0 {
            case .success(let realm):
                do {
                    if let equalItem = realm
                        .objects(FoodItem.self)
                        .filter("productID == %@", item.productID)
                        .filter({ $0.bestBeforeDate.isSameDay(item.bestBeforeDate) })
                        .first
                    {
                        try realm.write {
                            equalItem.amount += item.amount
                        }
                        completion?(.success(()))
                    } else {
                        try realm.write {
                            realm.add(item)
                        }
                        completion?(.success(()))
                    }
                    
                } catch (let error) {
                    completion?(.failure(.realmError(error)))
                }
            case .failure(let error):
                completion?(.failure(error as StoreError))
            }
        }
    }
    
    func all(_ completion: (Result<Results<FoodItem>, StoreError>) -> Void) {
        getRealm {
            switch $0 {
            case .success(let realm):
                completion(.success(realm.objects(FoodItem.self)))
            case .failure(let error):
                completion(.failure(error as StoreError))
            }
        }
    }
    
    
    func one(withID id: String, _ completion: (Result<FoodItem, StoreError>) -> Void) {
        getRealm {
            switch $0 {
            case .success(let realm):
                guard let item = realm.object(ofType: FoodItem.self, forPrimaryKey: id)
                    else {
                        completion(.failure(.objectNotFound))
                        return
                }
                completion(.success(item))
            case .failure(let error):
                completion(.failure(error as StoreError))
            }
        }
    }
    
    func update(id: String, _ updateHandler: @escaping (FoodItem) -> Void, errorHandler: ((StoreError) -> Void)? = nil) {
        self.one(withID: id, {
            switch $0 {
            case .success(let item):
                getRealm({
                    switch $0 {
                    case .success(let realm):
                        do {
                            try realm.write {
                                updateHandler(item)
                            }
                        } catch (let error) {
                            errorHandler?(.realmError(error))
                        }
                    case .failure(let error):
                        errorHandler?(.realmError(error))
                    }
                })
                
            case .failure(let error):
                errorHandler?(error)
            }
        })
    }
    
    func getProductNames(for itemIDs: [String], _ completion: @escaping (Result<[String: String], StoreError>) -> Void) {
        all { itemsResult in
            switch itemsResult {
            case .success(let items):
                var dict: [String: String] = [:]
                
                items.filter({ itemIDs.contains($0.id) }).forEach {
                    dict[$0.id] = $0.productID
                }
                
                Stores.products.all { productsResult in
                    switch productsResult {
                    case .success(let allProducts):
                        allProducts.filter({ dict.values.contains($0.id) }).forEach {
                            dict.fil
                        }
                    case .failure(let error):
                        completion(.failure(.realmError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.realmError(error)))
            }
        }
    }
}
