
//
//  MonthKey.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct MonthKey: Hashable {
    var month: Int
    var year: Int
    
    init(date: Date) {
        self.month = date.month
        self.year = date.year
    }
    
    init?(month: Int, year: Int) {
        guard month >= 1, month <= 12 else { return nil }
        self.month = month
        self.year = year
    }
    
    var hashValue: Int {
        return "\(self.month).\(self.year)".hashValue
    }
    
    var date: Date? {
        let cal = Calendar(identifier: .gregorian)
        let comps = DateComponents(calendar: cal, year: year, month: month, day: 1)
        return cal.date(from: comps)
    }
}

extension MonthKey: Equatable {}
func ==(lhs: MonthKey, rhs: MonthKey) -> Bool {
    return lhs.date == rhs.date
}

func <(lhs: MonthKey, rhs: MonthKey) -> Bool {
    guard let lhsDate = lhs.date, let rhsDate = rhs.date else { return false }
    return lhsDate < rhsDate
}

func >(lhs: MonthKey, rhs: MonthKey) -> Bool {
    guard let lhsDate = lhs.date, let rhsDate = rhs.date else { return false }
    return lhsDate > rhsDate
}
