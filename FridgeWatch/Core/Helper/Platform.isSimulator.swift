//
//  Platform.isSimulator.swift
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
