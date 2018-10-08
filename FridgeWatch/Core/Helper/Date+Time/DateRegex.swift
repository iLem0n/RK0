//
//  DateRegex.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 08.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct DateRegex {
    var pattern: String
    var templates: [String]
    var token: String
    var seperators: [String]
    var masks: [String]
    
    var allVariants: [String] {
        return self.seperators.map {
            pattern.replacingOccurrences(of: token, with: $0)
        }
    }
    
    func evaluate(_ string: String) -> Date? {
        func maskedVariant(_ variant: String) -> [String] {
            return string.matches(for: variant)
                .map ({
                    var result = $0
                    for mask in self.masks {
                        result = result.replacingOccurrences(of: mask, with: "")
                    }
                    return result
                })
                .filter({ !$0.isEmpty })
        }
        
        func detokenizedTemplate(_ template: String) -> [String] {
            var result: [String] = []
            for seperator in seperators {
                var seperator = seperator
                if seperator == "\\/" { seperator = "/" }
                let detokenized = template.replacingOccurrences(of: token, with: seperator)
                result.append(detokenized)
            }
            return result
        }
        
        guard let resultString = self.allVariants
            .map(maskedVariant)
            .filter({ $0.count > 0 })
            .reduce([] as [String], +)
            .first
        else { return nil }
        
        return templates
            .map(detokenizedTemplate)
            .reduce([] as [String], +)
            .map({
                return DateFormatter(template: $0).date(from: resultString)
            })
            .compactMap({ $0 }).first
    }
}
