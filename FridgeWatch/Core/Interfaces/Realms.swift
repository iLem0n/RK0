//
//  Realms.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift

final class Realms: NSObject, RealmsType {
    static let shared: RealmsType = Realms()
    
    public var local: Realm? {
        let config = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true, objectTypes: [FoodItem.self])
        
        do {
            return try Realm(configuration: config)
        } catch (let error) {
            log.error(error)
            return nil
        }
    }
}
