//
//  ScanCoordinatorType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol ScanCoordinatorType: CoordinatorType {
    var onScanFinished: (() -> Void)? { get set }
}
