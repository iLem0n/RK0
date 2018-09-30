//
//  ScannerState.swift
//  FridgeWatch
//
//  Created by iLem0n on 28.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

enum ScannerError: Error {
    case notSupportedByDevice
}

enum ScannerState {
    case tearUp
    case ready
    case processing
    case tearDown
    case error(ScannerError)
}

extension ScannerState {}
infix operator ==
func ==(_ lhs: ScannerState, _ rhs: ScannerState) -> Bool {
    switch lhs {
    case .tearUp:
        switch rhs {
        case .tearUp:
            return true
        default: return false
        }
    case .ready:
        switch rhs {
        case .ready:
            return true
        default: return false
        }
    case .processing:
        switch rhs {
        case .processing:
            return true
        default: return false
        }
    case .tearDown:
        switch rhs {
        case .tearDown:
            return true
        default: return false
        }
    case .error(let lError):
        switch rhs {
        case .error(let rError):
            return lError == rError
        default: return false
        }
    }
}

infix operator !=
func !=(_ lhs: ScannerState, _ rhs: ScannerState) -> Bool {
    return !(lhs == rhs)
}
