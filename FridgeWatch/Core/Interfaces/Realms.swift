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
    static var local: Realm {
        let config = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true, objectTypes: [Product.self, FoodItem.self])
        
        do {
            return try Realm(configuration: config)
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
    }
}
