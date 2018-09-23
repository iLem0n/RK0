//
//  SharedFactoryType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

protocol SharedFactoryType {
    func makeDatePickerModul(date: Date, onApply: @escaping (Date) -> Void, onClear: (() -> Void)?, onCancel: @escaping () -> Void) -> UIAlertController
}
