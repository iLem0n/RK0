//
//  ResponseParserType.swift
//  FridgeWatch
//
//  Created by iLem0n on 24.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol ResponseParserType {
    func parse(_ data: Data) -> ParsedResponse?
}
