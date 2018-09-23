//
//  GTINSucheResponseParser.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 21.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Freddy

final class GTINSucheResponse: NSObject, ProductDataResponseType {
    var names: [String] = []
    var brands: [String] = []
    var imageUrls: [URL] = []
    
    override var description: String {
        return "\nNames: \(self.names)\nBrands:\(self.brands)\nImageUrls: \(self.imageUrls)"
    }
}

struct GTINSucheResponseParser: ProductDataResponseParserType {
    func parse(_ data: Data) throws -> ProductDataResponseType? {
        guard var string = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        string = string.replacingOccurrences(of: "\n", with: "")
        guard let match = try! NSRegularExpression(pattern: "<h2>.*<\\/h2><h4>EAN\\/GTIN: [0-9]{8,13}",
                                                   options: .dotMatchesLineSeparators)
            .matches(in: string,
                     options: .withTransparentBounds,
                     range: NSRange(location: 0, length: string.count))
            .map({
                string[Range($0.range, in: string)!]
            })
            .first
            else { return nil }
        
        let matchString = String(match)
        guard let name = try! NSRegularExpression(pattern: "<h2>.*<\\/h2>", options: .dotMatchesLineSeparators)
            .matches(in: matchString,
                     options: .withTransparentBounds,
                     range: NSRange(location: 0, length: matchString.count))
            .map({ matchString[Range($0.range, in: matchString)!] })
            .first
            else { return nil }
        
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
//        
        let cleanName = String(name)
            .replacingOccurrences(of: "<h2>", with: "")
            .replacingOccurrences(of: "</h2>", with: "")
        
        let response = GTINSucheResponse()
        response.names.append(cleanName)
        return response
    }
}
