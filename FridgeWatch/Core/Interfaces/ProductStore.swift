//
//  ProductStore.swift
//  FridgeWatch
//
//  Created by iLem0n on 16.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import Result
import UIKit

enum ProductDataKey: String {
    case image
    case name
}

class ProductStore: NSObject {
    static let shared = ProductStore()
    private var dataFetchQueue: OperationQueue?
    
    private func getRealm(_ completion: @escaping (Result<Realm, StoreError>) -> Void) {
        do {
            //  initialize remote synced realm
            let host = "fridgewatch-products.de1a.cloud.realm.io"
            let credentials = SyncCredentials.usernamePassword(username: "fridgewatchapp", password: "fuftyw-Mofsyw-wefjy1", register: false)
            let realmServerURL = URL(string: "https://\(host)")!
            let realmSyncURL = URL(string: "realms://\(host)/~/fridgewatch-products")!
            
            SyncUser.logIn(with: credentials, server: realmServerURL, timeout: 0.1) { (syncUser, error) in
                if let error = error {
                    log.error(error.localizedDescription)
                    completion(.failure(.realmError(error)))
                    return
                }
                
                let syncConfig = SyncConfiguration(user: syncUser!, realmURL: realmSyncURL)
                
                SyncManager.shared.logLevel = .all
                SyncManager.shared.errorHandler = { (error, _) in
                    log.error("Realm Error: \(error)")
                }
                
                let config = Realm.Configuration(
                    syncConfiguration: syncConfig,
                    schemaVersion: 0,
                    migrationBlock: { migration, oldSchemaVersion in
                        log.debug("MigrationBlock called.")
                },
                    deleteRealmIfMigrationNeeded: true,
                    objectTypes: [Product.self])
                
                
                SyncManager.shared.logLevel = .error
                SyncManager.shared.errorHandler = { (error, _) in
                    log.error("Realm Error: \(error)")
                }
                
                guard let realm = try? Realm(configuration: config)
                    else {
                        log.error("Unable to create configured Product Realm.")
                        let error = NSError(
                            domain: "de.ilem0n.fridgewatch.realm",
                            code: 1,
                            userInfo: [
                                NSLocalizedDescriptionKey: NSLocalizedString("Unable to create configured Product Realm.", comment: "Unable to create configured Product Realm.")
                            ]
                        )
                        completion(.failure(.realmError(error)))
                        return
                }
                
                completion(.success(realm))
            }
        }
    }
    
    func all(_ completion: @escaping (Result<Results<Product>, StoreError>) -> Void) {
        getRealm {
            switch $0 {
            case .success(let realm):
                completion(.success(realm.objects(Product.self)))
            case .failure(let error):
                completion(.failure(error as StoreError))
            }
        }
    }
    
    
    func product(withID id: String, _ completion: @escaping (Result<Product, StoreError>) -> Void) {
        getRealm { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let realm):
                guard let object = realm.object(ofType: Product.self, forPrimaryKey: id)
                    else {
                        strong.createNewProduct(id: id, completion)
                        return
                }
                completion(.success(object))
            case .failure(let error):
                completion(.failure(error as StoreError))
            }
        }
    }
    
    private func createNewProduct(id: String, _ completion: @escaping (Result<Product, StoreError>) -> Void) {
        fetchPoductData(id: id, { [weak self] (productData) in
            guard let strong = self else { return }
            
            strong.getRealm {
                switch $0 {
                case .success(let realm):
                    do {
                        if let existing = realm.object(ofType: Product.self, forPrimaryKey: id) {
                            completion(.success(existing))
                        } else {
                            try realm.write {
                                let new = Product(id: id)
                                new.name = productData[.name] as? String
                                new.image = productData[.image] as? UIImage
                                realm.add(new)
                                
                                completion(.success(new))
                            }
                        }
                    } catch (let error) {
                        completion(.failure(.realmError(error)))
                    }
                case .failure(let error):
                    completion(.failure(error as StoreError))
                }
            }
        })
    }
    
    func update(id: String, _ updateHandler: @escaping (Product) -> Void, errorHandler: ((StoreError) -> Void)? = nil) {
        self.product(withID: id, { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let product):
                strong.getRealm {
                    switch $0 {
                    case .success(let realm):
                        do {
                            try realm.write {
                                updateHandler(product)
                            }
                        } catch (let error) {
                            errorHandler?(.realmError(error))
                        }
                    case .failure(let error):
                        errorHandler?(.realmError(error))
                    }
                }
            case .failure(let error):
                errorHandler?(error)
            }
        })
    }
    
    private func fetchPoductData(id: String, _ completion: @escaping ([ProductDataKey: Any]) -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async { [weak self] in
            guard let strong = self else { return }
            let imageSearchOperation = ImageSearchOperation(gtin: id)
            let dataSearchOperation = DataSearchOperation(gtin: id)
            
            strong.dataFetchQueue = OperationQueue()
            strong.dataFetchQueue?.addOperation(imageSearchOperation)
            strong.dataFetchQueue?.addOperation(dataSearchOperation)
            
            strong.dataFetchQueue?.waitUntilAllOperationsAreFinished()
            
            var resultDict: [ProductDataKey: Any] = [:]
            if let image = imageSearchOperation.resultImage {
                resultDict[.image] = image
            }
            
            if let name = dataSearchOperation.resultName {
                resultDict[.name] = name
            }
            completion(resultDict)
        }
    }
}
