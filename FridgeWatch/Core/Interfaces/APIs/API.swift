//
//  API.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 28.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Freddy

protocol APIType {
    var parser: ProductDataResponseParserType { get }
    
    func makeProduct(data: Data) -> Product?
}

enum API: APIType {
    case datakick
    case gtinsuche
    case googleImageSearch
    case codecheck

    var supportedDataTypes: [APIDataTypeKey] {
        switch self {
        case .googleImageSearch:
            return [.productImage]
        default:
            return []
        }
    }
    
    func makeProduct(data: Data) -> Product? {
        guard itemFound(data: data) else { return nil }
        var data = data
        
        let gtinKey: String
        let nameKey: String
        let brandKey: String
        
        switch self {
        case .codecheck:
            gtinKey = "gtin"
            nameKey = "name"
            brandKey = "brand"
        case .googleImageSearch:
            gtinKey = "gtin"
            nameKey = "name"
            brandKey = "brand"
        case .gtinsuche:
            guard let parsed = GTINSucheParser(data).parsedJSONData else { return nil }
            data = parsed
            gtinKey = "gtin"
            nameKey = "name"
            brandKey = "brand"
        case .datakick:
            gtinKey = "gtin14"
            nameKey = "name"
            brandKey = "brand_name"
        }
        
        guard let json = try? JSON(data: data)
        else {
            log.error("Unable to convert data to JSON:\nData:\n\(String(data: data, encoding: String.Encoding.utf8)!)")
            return nil
        }

        guard let gtin = try? json.getString(at: gtinKey)
            else { log.error("\(self) | Field not found: '\(gtinKey)'\nJSON:\n\(json)"); return nil }
        
        guard let name = try? json.getString(at: nameKey)
            else { log.error("\(self) | Field not found: '\(nameKey)'\nJSON:\n\(json)"); return nil  }
        
        guard let brand = try? json.getString(at: brandKey)
            else { log.error("\(self) | Field not found: '\(brandKey)'\nJSON:\n\(json)"); return nil  }

        return Product(gtin: gtin)
    }
    
    func itemFound(data: Data) -> Bool {
        switch self {
        case .codecheck:
            return false
        case .googleImageSearch:
            return false
        case .gtinsuche:
            guard let string = String(data: data, encoding: String.Encoding.utf8) else { return false }
            if string == "EAN nicht eingetragen!" { return false }
            return true
        case .datakick:
            guard let json = try? JSON(data: data)
            else {
                let dataString = String(describing: String(data: data, encoding: String.Encoding.utf8))
                log.error("Unable to convert data to JSON:\nData:\n\(dataString)")
                return false
            }
            guard let message = try? json.getString(at: "message"), message == "Item not found" else { return true }
            return false
        }
    }
    
    var parser: ProductDataResponseParserType {
        switch self {
        case .gtinsuche:
            return GTINSucheResponseParser()
        case .codecheck:
            return CodecheckResponseParser()
        case .datakick:
            return DataKickResponseParser()
        case .googleImageSearch:
            return GoogleSearchResponseParser()
        }
    }
}

