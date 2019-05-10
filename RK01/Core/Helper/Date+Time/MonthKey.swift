
//
//  MonthKey.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

/**
 Maps the given month into a hashable value
 */
struct MonthKey: Hashable {
    let month: Int
    let year: Int
    
    /**
     Init with date
    
     - parameter date: The date from with the month and year will be extracted
     */
    init(date: Date) {
        self.month = date.month
        self.year = date.year
    }
    
    /**
     Init with month and year.
     
     - parameter month: The month. Must be between 1-12
     - parameter year: The year
     */
    init?(month: Int, year: Int) {
        guard month >= 1, month <= 12 else { return nil }
        self.month = month
        self.year = year
    }
    

    var hashValue: Int {
        return "\(self.month).\(self.year)".hashValue
    }
}

//  Make MonthKey compareable by operator
extension MonthKey: Equatable {}

/**
 Compares two MonthKey's
 - returns: *true* if the year and month (and ) is equal
 */
func ==(lhs: MonthKey, rhs: MonthKey) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

/**
 Compares two MonthKey's
 - returns: *true* if the year from lvalue is earlier or equal then the rvalue and the month is earlier
 */
func <(lvalue: MonthKey, rvalue: MonthKey) -> Bool {
    return lvalue.year <= rvalue.year && lvalue.month < rvalue.month
}

/**
 Compares two MonthKey's
 - returns: *true* if the year from lvalue is later or equal then the rvalue and the month is later
 */
func >(lvalue: MonthKey, rvalue: MonthKey) -> Bool {
    return lvalue.year >= rvalue.year && lvalue.month > rvalue.month
}
