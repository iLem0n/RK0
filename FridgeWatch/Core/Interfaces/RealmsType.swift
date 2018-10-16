//
//  RealmsType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol RealmsType: class {
    var items: Realm! { get }
    var products: Realm? { get }
}
