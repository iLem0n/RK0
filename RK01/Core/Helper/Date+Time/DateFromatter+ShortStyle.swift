//
//  DateFromatterInit.swift
//  CoinBag
//
//  Created by Peter Christian Glade on 26.03.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import UIKit

extension DateFormatter {
    convenience init(timeStyle: DateFormatter.Style, dateStyle: DateFormatter.Style) {
        self.init()
        self.timeStyle = timeStyle
        self.dateStyle = dateStyle
    }
    
    convenience init(style: DateFormatter.Style) {
        self.init()
        self.timeStyle = style
        self.dateStyle = style
    }
    
    convenience init(template: String) {
        self.init()
        self.dateFormat = template
    }
}
