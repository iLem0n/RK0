//
//  License.swift
//  FridgeWatch
//
//  Created by iLem0n on 21.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

struct Licenses: Decodable {
    class License: Decodable {
        let title: String
        let link: String
        let type: String
        let licenseLink: String
        private(set) var licenseText: String!
        
        private enum CodingKeys: String, CodingKey {
            case title = "title"
            case link = "link"
            case type = "type"
            case licenseLink = "licenseLink"
        }                    
        
        func fetchLicenseText() {
            do {
                let data = try Data(contentsOf: URL(string: self.licenseLink)!)
                
                guard let text = String(data: data, encoding: String.Encoding.utf8)
                else {
                    self.licenseText = "Unable to retrieve License"
                    return
                }
                self.licenseText = text
            } catch (let error) {
                log.error(error.localizedDescription)
            }            
        }
    }

    let licences: [License]
    
    private enum CodingKeys: String, CodingKey {
        case licences = "licences"
    }
}
