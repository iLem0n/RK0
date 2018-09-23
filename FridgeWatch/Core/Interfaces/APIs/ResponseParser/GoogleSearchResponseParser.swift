//
//  GoogleSearchResponse.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 21.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Freddy
import UIKit

final class GoogleSearchResponse: NSObject, ProductDataResponseType {
    var names: [String] = []
    var brands: [String] = []
    var imageUrls: [URL] = []

    override var description: String {
        return "\nNames: \(self.names)\nBrands:\(self.brands)\nImageUrls: \(self.imageUrls)"
    }
}

struct GoogleSearchResponseParser: ProductDataResponseParserType {
    func parse(_ data: Data) throws -> ProductDataResponseType? {
        let json = try JSON(data: data)
        
        let responseData = GoogleSearchResponse()
        for item in try json.getArray(at: "items").map({ GoogleResultItem(json: $0) }).compactMap({ $0 }) {
            if let name = item.name { responseData.names.append(name) }
            if let brand = item.brand { responseData.brands.append(brand) }
            if let imageUrl = item.imageUrl { responseData.imageUrls.append(imageUrl) }
        }
        log.debug(responseData)
        return responseData
    }
}

fileprivate struct GoogleResultItem {
    private var pageMap: GooglePageMap?
    
    init?(json: JSON) {
        do {
            self.pageMap = GooglePageMap(jsonDict: try json.getDictionary(at: "pagemap"))
        } catch {
            log.error(error.localizedDescription)
            return nil
        }
    }
    
    var brand: String? { return self.pageMap?.productBrand }
    var name: String? { return self.pageMap?.productName }
    var imageUrl: URL? { return self.pageMap?.imageUrl }
}

fileprivate struct GooglePageMap {
    private(set) var productName: String?
    private(set) var productBrand: String?
    private(set) var imageUrl: URL?
    
    init?(jsonDict: [String: JSON]) {
        log.debug(jsonDict)
        do {
            guard let infoArray = try jsonDict["product"]?.getArray() else { return nil }
            for info in infoArray {
                log.debug("INFO: \(info)")
            }
        } catch {
            
        }
//        //  parse product name and brand
//        if let infoArrayOptional = try? jsonDict["product"]?.getArray(),
//            let infoArray = infoArrayOptional {
//            for info in infoArray {
//                //  if we have a brand we should use the name in the data set
//                if self.productBrand == nil,
//                    let manufacturer = try? info.getString(at: "manufacturer") {
//                    self.productBrand = manufacturer
//
//                    if let name = try? info.getString(at: "name") {
//                       self.productName = name
//                    }
//                }
//
//                //  get product name if not yet provided
//                if self.productName == nil,
//                    let name = try? info.getString(at: "name") {
//                    self.productName = name
//                }
//            }
//        }
//
//        //  parse product image
//        if let imageUrlValue = try? jsonDict["cse_image"]?.getArray().first?.getDictionary()["src"]?.getString(),
//            let imageUrlString = imageUrlValue,
//            let imageUrl = URL(string: imageUrlString) {
//            self.imageUrl = imageUrl
//        }
    }
}
