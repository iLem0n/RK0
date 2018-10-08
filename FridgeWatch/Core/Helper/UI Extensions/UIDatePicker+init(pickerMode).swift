//
//  UIDatePicker+init(pickerMode).swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 22.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

extension UIDatePicker {
    convenience init(pickerMode: UIDatePicker.Mode) {
        self.init()
        self.datePickerMode = pickerMode
    }
}
