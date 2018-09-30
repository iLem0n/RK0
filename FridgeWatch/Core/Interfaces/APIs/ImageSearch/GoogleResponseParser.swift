//
//  GoogleResponseParser.swift
//  FridgeWatch
//
//  Created by iLem0n on 24.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit
import Freddy

class GoogleImageResponseParser: ResponseParserType {
    func parse(_ data: Data) -> ParsedResponse? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            if let error = try decoder.decode(GoogleErrorResponse.self, from: data).error {
                log.error(error)
                return nil
            }
            
            let searchInfo = try decoder.decode(GoogleSearchInformationResponse.self, from: data)
            guard
                let resultCount = Int(searchInfo.searchInformation.totalResults),
                resultCount > 0
            else { return nil }
            
            
            
            return try decoder.decode(GoogleImageResponse.self, from: data)
        } catch (let error) {
            log.error(error)
            return nil
        }
    }
}
