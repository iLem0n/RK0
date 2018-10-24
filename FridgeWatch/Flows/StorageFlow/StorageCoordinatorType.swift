//
//  StorageCoordinatorType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol StorageCoordinatorType: CoordinatorType {
    ///  called when we want to scan new products
    var onScanFlowRequest: (() -> Void)? { get set }
    
    ///  called when we need the settings flow
    var onSettingsRequest: (() -> Void)? { get set }
}
