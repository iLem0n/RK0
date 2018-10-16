//
//  Stores.swift
//  FridgeWatch
//
//  Created by iLem0n on 16.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

enum StoreError: Error {
    case objectNotFound
    case realmError(Error)
}

final class Stores {
    static let items = ItemStore()
    static let products = ProductStore()
}
