//
//  Date+QuickValues.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 23.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation

extension Date {
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}
