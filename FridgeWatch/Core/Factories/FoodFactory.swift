//
//  FoodFactory.swift
//  FridgeWatch
//
//  Created by iLem0n on 03.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class FoodFactory: FoodFactoryType {

    static func saveFoodItem(_ item: FoodItem) throws {
        
        let realm = Realms.local
        let existingItem = realm
            .objects(FoodItem.self)
            .filter({
                $0.product.gtin == item.product.gtin &&
                $0.bestBeforeDate.isSameDay(item.bestBeforeDate) &&
                $0.available
            })
            .first
        
        if let existingItem = existingItem {
            try realm.write {
                existingItem.amount += item.amount
            }
        } else {
            try realm.write {
                realm.add(item)
            }
        }
    }
}

extension Date {
    func isSameDay(_ otherDate: Date) -> Bool {
        return self.day == otherDate.day && self.month == otherDate.month && self.year == otherDate.year
    }
}
