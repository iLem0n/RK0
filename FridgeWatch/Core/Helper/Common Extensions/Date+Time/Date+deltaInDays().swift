//
//  Date+deltaInDays().swift
//  FridgeWatch
//
//  Created by iLem0n on 05.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension Date {
    func deltaInDays(to anotherDate: Date) -> Int {
        var selfMorningComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        selfMorningComps.hour = 0
        selfMorningComps.minute = 0
        
        var refMorningComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: anotherDate)
        refMorningComps.hour = 0
        refMorningComps.minute = 1
        
        let todayMorning = Calendar.current.date(from: selfMorningComps)
        let refMorning = Calendar.current.date(from: refMorningComps)
        
        return Calendar.current.dateComponents([.day, .hour, .minute], from: todayMorning!, to: refMorning!).day!
    }
}
