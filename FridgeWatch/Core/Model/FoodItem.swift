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
    @objc dynamic var productID: String!
    @objc dynamic var amount: Int = 1
    @objc dynamic var consumed: Int = 0
    @objc dynamic var thrownAway: Int = 0
    @objc dynamic var available: Bool { get { return amount > consumed + thrownAway } }
    
    lazy var productObservable: Observable<Product> = self.productSubject.filter({ $0 != nil }).map({ $0! }).asObservable()
    private let productSubject = BehaviorSubject<Product?>(value: nil)
    
    convenience init(bestBeforeDate: Date, productID: String, amount: Int = 1) {
        self.init()
        self.bestBeforeDate = bestBeforeDate
        self.amount = amount
        self.productID = productID
        
        Stores.products.product(withID: productID) { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let product):
                strong.productSubject.onNext(product)
            default: break
            }
        }
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["productObservable", "productSubject"]
    }
    
    var availableAmount: Int {
        return amount - (consumed + thrownAway)
    }
}
