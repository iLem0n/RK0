//
//  FoodItem.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

final class FoodItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var bestBeforeDate: Date!
    @objc dynamic var product: Product!
    @objc dynamic var amount: Int = 1
    @objc dynamic var consumed: Int = 0
    @objc dynamic var thrownAway: Int = 0
    @objc dynamic var available: Bool { get { return amount > consumed + thrownAway } }
    

    convenience init(bestBeforeDate: Date, productGTIN: String, amount: Int = 1) {
        self.init()
        self.bestBeforeDate = bestBeforeDate
        self.amount = amount
        self.product = Realms.shared.object(ofType: Product.self, forPrimaryKey: productGTIN)!
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    var availableAmount: Int {
        return amount - (consumed + thrownAway)
    }
}
