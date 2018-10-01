//
//  GTINValidator.swift
//  FridgeWatch
//
//  Created by iLem0n on 30.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class GTINValidator {
    static func validate(_ gtin: String) -> Bool {
        return checkLenght(gtin) && checkChecksum(gtin)
    }
    
    private static func checkLenght(_ gtin: String) -> Bool {
        switch gtin.count {
        case 8, 12, 13, 14:
            return true
        default:
            return false
        }
    }
    
    private static func checkChecksum(_ input: String) -> Bool {
        var string = input
        let lastDigit = string.removeLast()
        let expected = checkSum(string)
        
        log.debug("\(lastDigit) == \(expected)")
        
        return true
    }
    
    private static func checkSum(_ input: String) -> Int {
        var result = 0
        for (idx, char) in input.reversed().enumerated() {
            if idx % 2 == 1 {
                result += Int("\(char)")!
            } else {
                result += Int("\(char)")! * 3
            }
        }
        return (10 - (result % 10)) % 10
    }
}
