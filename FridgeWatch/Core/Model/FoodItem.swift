//
//  FoodItem.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift

final class FoodItem: Object {
    @objc dynamic var gtin: String!
    @objc dynamic var date: Date!

    convenience init(gtin: String, date: Date) {
        self.init()
        self.gtin = gtin
        self.date = date
    }
}
