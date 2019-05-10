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
import UIKit

struct ProductInfo {
    let id: String
    let name: String
    let image: UIImage
    
    init(id: String, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
}

public final class FoodItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var bestBeforeDate: Date!
    @objc dynamic var productID: String!
    @objc dynamic var amount: Int = 1
    @objc dynamic var consumed: Int = 0
    @objc dynamic var thrownAway: Int = 0
    @objc dynamic var available: Bool { get { return amount > consumed + thrownAway } }
    
    var productInfo: ProductInfo?
    
    lazy var productObservable: Observable<Product> = self.productSubject.filter({ $0 != nil }).map({ $0! }).asObservable()
    private let productSubject = BehaviorSubject<Product?>(value: nil)
    
    
    convenience init(bestBeforeDate: Date, productID: String, amount: Int = 1) {
        self.init()
        self.bestBeforeDate = bestBeforeDate
        self.amount = amount
        self.productID = productID
    }
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["productObservable", "productSubject", "productInfo"]
    }
    
    public var availableAmount: Int {
        return amount - (consumed + thrownAway)
    }
}
