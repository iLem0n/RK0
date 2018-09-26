////
////  GTINSucheParser.swift
////  FoodWatch
////
////  Created by Peter Christian Glade on 21.05.18.
////  Copyright © 2018 Peter Christian Glade. All rights reserved.
////
//
//import Foundation
//
//final class GTINSucheParser {
//    private let inputData: Data
//    init(_ data: Data) {
//        self.inputData = data
//    }
//    
//    var parsedJSONData: Data? {
//        guard var string = String(data: self.inputData, encoding: String.Encoding.utf8) else { return nil }
//        
//        string = string.replacingOccurrences(of: "\n", with: "")
//        guard let match = try! NSRegularExpression(pattern: "<h2>.*<\\/h2><h4>EAN\\/GTIN: [0-9]{8,13}",
//                                                   options: .dotMatchesLineSeparators)
//            .matches(in: string,
//                     options: .withTransparentBounds,
//                     range: NSRange(location: 0, length: string.count))
//            .map({
//                string[Range($0.range, in: string)!]
//            })
//            .first
//            else { return nil }
//        
//        let matchString = String(match)
//        guard let name = try! NSRegularExpression(pattern: "<h2>.*<\\/h2>", options: .dotMatchesLineSeparators)
//            .matches(in: matchString,
//                     options: .withTransparentBounds,
//                     range: NSRange(location: 0, length: matchString.count))
//            .map({ matchString[Range($0.range, in: matchString)!] })
//            .first
//            else { return nil }
//        
//        guard let gtin = try! NSRegularExpression(pattern: "<h4>EAN\\/GTIN: [0-9]{8,13}",
//                                                  options: .dotMatchesLineSeparators)
//            .matches(in: matchString,
//                     options: .withTransparentBounds,
//                     range: NSRange(location: 0, length: matchString.count))
//            .map({ matchString[Range($0.range, in: matchString)!] })
//            .first
//            else { return nil }
//        
//        let cleanGTIN = String(gtin)
//            .replacingOccurrences(of: "<h4>EAN/GTIN: ", with: "")
//        let cleanName = String(name)
//            .replacingOccurrences(of: "<h2>", with: "")
//            .replacingOccurrences(of: "</h2>", with: "")
//        log.debug(cleanName)
//        return try? JSONSerialization.data(withJSONObject: ["gtin": cleanGTIN, "name": cleanName, "brand": ""],
//                                           options: .sortedKeys)
//    }
//}
