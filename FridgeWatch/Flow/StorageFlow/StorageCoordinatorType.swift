//
//  StorageCoordinatorType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol StorageCoordinatorType: CoordinatorType {
    var onScanFlowRequest: (() -> Void)? { get set }
    var onSettingsRequest: (() -> Void)? { get set }
}
