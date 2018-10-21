//
//  Product.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 22.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

final class Product: Object {
    @objc dynamic var id: String!
    @objc dynamic var name: String?
    @objc dynamic var imageData: Data?
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
    
    var image: UIImage? {
        get {
            guard let imageData = self.imageData else { return nil }
            return UIImage(data: imageData, scale: 1.0)
        }
        set {
            guard let image = newValue
            else {
                self.imageData = nil
                return 
            }
            
            self.imageData = image.pngData()
        }
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}

