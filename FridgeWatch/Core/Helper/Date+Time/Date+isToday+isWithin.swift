//
//  Date+isToday+isWithin.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 08.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension Date {
    func isToday() -> Bool {
        let now = Date()
        
        return
            self.day == now.day &&
            self.month == now.month &&
            self.year == now.year
    }
    
    func isWithin(days: Int) -> Bool {
        guard let daysBetween = Calendar.current.dateComponents([.day], from: Date(), to: self).day else { return false }
        return daysBetween >= 0 && daysBetween <= days
    }
}

