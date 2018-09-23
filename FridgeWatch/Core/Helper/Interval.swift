//
//  PaymentInterval.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 04.07.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation

enum Interval: Int {
    case monthly
    case quarterly
    case halfyearly
    case yearly
    
    var factor: Int {
        switch self {
        case .monthly: return 1
        case .quarterly: return 3
        case .halfyearly: return 6
        case .yearly: return 12
        }
    }
    
    var string: String {
        switch self {
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        case .halfyearly: return "Half-Yearly"
        case .yearly: return "Yearly"
        }
    }
}
