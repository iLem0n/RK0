//
//  DataKickResponseParser.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 21.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Freddy

final class DataKickResponse: NSObject, ProductDataResponseType {
    var names: [String] = []
    var brands: [String] = []
    var imageUrls: [URL] = []
    
    override var description: String {
        return "\nNames: \(self.names)\nBrands:\(self.brands)\nImageUrls: \(self.imageUrls)"
    }
}

struct DataKickResponseParser: ProductDataResponseParserType {
    func parse(_ data: Data) throws -> ProductDataResponseType? {
        return DataKickResponse()
    }
}
