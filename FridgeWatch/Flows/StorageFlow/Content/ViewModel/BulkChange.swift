//
//  BulkEditingMode.swift
//  FridgeWatch
//
//  Created by iLem0n on 08.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

/**
 determines which editing mode is actually enabled in Storage overviewe
 */
enum BulkEditingMode {
    case none
    case consume
    case throwAway
}

/**
 The action and the amount which should be executed
 */
enum BulkChangeAction {
    case consume(Int)
    case throwAway(Int)
}

/**
 For temporary store the requested changes while bulk editing is enabled
 */
struct BulkChangeItem {
    /// The unique id of the item which chould be changed, neccessary for thread safe realm operations
    let itemID: String
    
    /// The action which should be executed on commit
    var action: BulkChangeAction
}
