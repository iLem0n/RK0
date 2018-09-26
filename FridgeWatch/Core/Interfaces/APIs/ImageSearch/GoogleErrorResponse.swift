//
//  GoogleErrorResponse.swift
//  FridgeWatch
//
//  Created by iLem0n on 25.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct GoogleErrorResponse: Decodable {
    struct GError: Decodable {
        struct GErrorArray: Decodable {
            let domain: String
            let reason: String
            let message: String
            let extendedHelp: String
            
            private enum CodingKeys: String, CodingKey {
                case domain = "domain"
                case reason = "reason"
                case message = "message"
                case extendedHelp = "extendedHelp"
            }
        }
        
        let errors: [GErrorArray]
        let code: Int
        let message: String
        
        private enum CodingKeys: String, CodingKey {
            case errors = "errors"
            case code = "code"
            case message = "message"
        }
    }
    
    let error: GError?
    
    private enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}
