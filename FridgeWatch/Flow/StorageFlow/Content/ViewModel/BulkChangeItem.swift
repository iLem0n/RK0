//
//  BulkChangeItem.swift
//  FridgeWatch
//
//  Created by iLem0n on 09.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

enum BulkChangeAction {
    case consume(Int)
    case throwAway(Int)
}

struct BulkChangeItem {
    let itemID: String
    var action: BulkChangeAction
}
