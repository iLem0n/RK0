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
    @objc dynamic var bestBeforeDate: Date!
    @objc dynamic var product: Product!
    
    convenience init(bestBeforeDate: Date, product: Product) {
        self.init()
        self.bestBeforeDate = bestBeforeDate
        self.product = product
    }
}
