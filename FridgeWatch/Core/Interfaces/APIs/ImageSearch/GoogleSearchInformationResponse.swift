//
//  GoogleSearchInformationResponse.swift
//  FridgeWatch
//
//  Created by iLem0n on 25.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct GoogleSearchInformationResponse: Decodable {
    struct SearchInformation: Decodable {
        let searchTime: Float
        let formattedSearchTime: String
        let totalResults: String
        let formattedTotalResults: String
        
        private enum CodingKeys: String, CodingKey {
            case searchTime = "searchTime"
            case formattedSearchTime = "formattedSearchTime"
            case totalResults = "totalResults"
            case formattedTotalResults = "formattedTotalResults"
        }
    }
    
    let searchInformation: SearchInformation
    
    private enum CodingKeys: String, CodingKey {
        case searchInformation = "searchInformation"
    }
}
