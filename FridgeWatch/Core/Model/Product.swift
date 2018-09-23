//
//  Product.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 22.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift

final class Product: Object {
    @objc dynamic var gtin: String!
    @objc dynamic var name: String?
    
    convenience init(gtin: String) {
        self.init()
        self.gtin = gtin
    }
    
    override static func primaryKey() -> String {
        return "gtin"
    }
}

