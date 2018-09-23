//
//  DateRange.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 21.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation

struct DateRange {
    let from: Date
    let to: Date
    
    init(_ from: Date, _ to: Date) {
        self.from = from
        self.to = to
    }
    
    var diffDays: Int {
        return Calendar.current.dateComponents([.day], from: from, to: to).day!
    }
    
    var fromComponents: DateComponents {
        return Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: from)
    }
    
    var toComponents: DateComponents {
        return Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: to)
    }
}

extension DateRange: Equatable {}
func ==(lhs: DateRange, rhs: DateRange) -> Bool {
    return lhs.from == rhs.from && lhs.to == rhs.to
}

extension DateRange {
    static var actualDay: DateRange {
        return day(from: Date())
    }

    static var actualWeek: DateRange {
        return week(from: Date())
    }

    static var actualMonth: DateRange {
        return month(from: Date())
    }
    
    static var actualYear: DateRange {
        return year(from: Date())
    }

    static func day(from date: Date) -> DateRange {
        var comps = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        comps.hour = 0
        comps.minute = 0
        let start = Calendar.current.date(from: comps)!
        
        comps.day! += 1
        let end = Calendar.current.date(from: comps)!.addingTimeInterval(-1)
        
        return DateRange(start, end)
    }
    
    static func week(from date: Date) -> DateRange {
        var comps = Calendar.current.dateComponents([.minute, .hour, .day, .weekday, .month, .year], from: date)
        comps.hour = 0
        comps.minute = 0
        
        while comps.weekday! != 2 {
            comps.day! -= 1
            comps = Calendar.current.dateComponents([.minute, .hour, .day, .weekday, .month, .year], from: Calendar.current.date(from: comps)!)
        }
        
        let start = Calendar.current.date(from: comps)!
        
        comps.day! += 7
        let end = Calendar.current.date(from: comps)!.addingTimeInterval(-1)
        
        return DateRange(start, end)
    }
    
    static func month(from date: Date) -> DateRange {
        var comps = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        comps.hour = 0
        comps.minute = 0
        comps.day = 1
        let start = Calendar.current.date(from: comps)!
        
        comps.month! += 1
        let end = Calendar.current.date(from: comps)!.addingTimeInterval(-1)
        return DateRange(start, end)
    }
    
    static func year(from date: Date) -> DateRange {
        var comps = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
        comps.hour = 0
        comps.minute = 0
        comps.day = 1
        comps.month = 1
        let start = Calendar.current.date(from: comps)!
        
        comps.year! += 1
        let end = Calendar.current.date(from: comps)!.addingTimeInterval(-1)
        return DateRange(start, end)
    }
}

extension DateRange: CustomStringConvertible {
    var description: String {
        let df = DateFormatter(timeStyle: .short, dateStyle: .medium)
        return "\(df.string(from: self.from)) - \(df.string(from: self.to))"
    }
}

extension Date {
    func isInRange(_ range: DateRange, regardingInterval interval: Interval? = nil) -> Bool {
        if self >= range.from && self <= range.to  { // If date is direct in range return true
            return true
        } else if self > range.to { // If date is after range it cannot match
            return false
        } else if let interval = interval {
            // date is before range -> check if date matches if interval is added
            let diff = Calendar.current.dateComponents([.day, .month, .year], from: self, to: range.to)
            let iterations = (diff.month! + (diff.day! > 0 ? 1 : 0) + (diff.year ?? 0) * 12) / interval.factor
            
            for idx in 1...iterations {
                if Calendar.current
                    .date(byAdding: .month, value: idx*interval.factor, to: self)!
                    .isInRange(range) {
                    return true
                }
            }
            return false
        } else {
            return false
        }
    }
}

