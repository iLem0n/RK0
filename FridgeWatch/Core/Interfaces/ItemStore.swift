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
    private var realm: Realm?
    
    private func getRealm(_ completion: (Result<Realm, StoreError>) -> Void) {
        if let realm = realm {
            completion(.success(realm))
            return
        }
        
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
                    try realm.write {
                        realm.add(item)
                    }
                    completion?(.success(()))
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
        self.one(withID: id, { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let item):
                do {
                    try strong.realm!.write {  //  !  if we have a produiczt here, there must be a realm
                        updateHandler(item)
                    }
                } catch (let error) {
                    errorHandler?(.realmError(error))
                }
            case .failure(let error):
                errorHandler?(error)
            }
        })
    }
}
