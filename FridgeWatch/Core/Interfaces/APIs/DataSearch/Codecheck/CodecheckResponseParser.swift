//
//  CodecheckResponseParser.swift
//  FridgeWatch
//
//  Created by iLem0n on 29.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import SwiftSoup

class CodecheckResponseParser: ResponseParserType {
    
    func parse(_ data: Data) -> ParsedResponse? {
        do {
            guard let htmlString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
            let doc: Document = try SwiftSoup.parse(String(htmlString))
            guard let element: Element = try doc.select("body > div.page.product-info > div.page-title > div.page-title-headline > div > h1").first() else { return nil }
            let name = try element.html()
                        
            return CodecheckResponse(names: [name])
        } catch (let error) {
            log.error(error)
            return nil
        }
    }
}
