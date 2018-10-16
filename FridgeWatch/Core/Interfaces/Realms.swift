//
//  Realms.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift

//final class Realms: NSObject, RealmsType {
//    static let shared: RealmsType = Realms()
//    
//    private(set) var items: Realm!
//    private(set) var productsRealm: Realm?
//    
//    override init() {
//        super.init()
//        
//        self.items = makeFoodItemsRealm()
//        
//        makeProductRealm { (realm) in            
//            ProductManager.shared.getProductData("4001242005200") { (result) in
//                log.debug(result)
//            }
//        }
//    }
//    
//    
//    private func makeFoodItemsRealm() -> Realm {
//        do {
//            let config = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true, objectTypes: [FoodItem.self])
//            return try Realm(configuration: config)
//        } catch (let error) {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    private func makeProductRealm(_ completion: @escaping (Realm) -> Void) {
//        //  return allready existing products realm
//        guard self.productsRealm != nil else {
//            completion(self.productsRealm!)
//            return
//        }
//        
//        //  initialize new remote synced realm
//        let host = "10.0.0.10"
//        let credentials = SyncCredentials.usernamePassword(username: "fridgewatch@ilem0n.de", password: "fuftyw-Mofsyw-wefjy1", register: false)
//        let realmServerURL = URL(string: "http://\(host):9080")!
//        let realmSyncURL = URL(string: "realm://\(host):9080/~/FridgeWatch-Products")!
//        
//        SyncUser.logIn(with: credentials, server: realmServerURL, timeout: 0.1) { (syncUser, error) in
//            if let error = error {
//                log.error(error.localizedDescription)
//                completion(nil)
//                return
//            }
//            
//            let syncConfig = SyncConfiguration(user: syncUser!, realmURL: realmSyncURL)
//            
//            SyncManager.shared.logLevel = .error
//            SyncManager.shared.errorHandler = { (error, _) in
//                log.error("Realm Error: \(error)")
//            }
//            
//            let config = Realm.Configuration(
//                syncConfiguration: syncConfig,
//                schemaVersion: 0,
//                migrationBlock: { migration, oldSchemaVersion in
//                    log.debug("MigrationBlock called.")
//            },
//                deleteRealmIfMigrationNeeded: true,
//                objectTypes: [Product.self])
//            
//            
//            
//            SyncManager.shared.logLevel = .error
//            SyncManager.shared.errorHandler = { (error, _) in
//                log.error("Realm Error: \(error)")
//            }
//            
//            guard let realm = try? Realm(configuration: config)
//            else {
//                log.error("Unable to create configured Product Realm.")
//                completion(nil)
//                return
//            }
//            
//            self.productsRealm = realm
//            completion(realm)
//        }
//    }
//}
