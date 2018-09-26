//
//  GTINSucheResponseParser.swift
//  FridgeWatch
//
//  Created by iLem0n on 25.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class GTINSucheResponseParser: ResponseParserType {
    
    func parse(_ data: Data) -> ParsedResponse? {
        do {
            guard let htmlString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
            let doc: Document = try SwiftSoup.parse(String(htmlString))
            let element: Element = try doc.select("#inhalt > h2").first()!
            let name = try element.html()

            return GTINSucheResponse(names: [name])
            
        } catch (let error) {
            log.error(error)
            return nil
        }
    }
}
