//
//  String+regex.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 08.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let range = NSRange(self.startIndex..., in: self)
            let results = regex
                .matches(in: self, range: range)
            
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
