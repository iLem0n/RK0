//
//  RealmsType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmsType: class {
    static var local: Realm { get }
}
