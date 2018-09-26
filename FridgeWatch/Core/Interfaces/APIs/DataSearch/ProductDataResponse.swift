//
//  ProductDataResponse.swift
//  FridgeWatch
//
//  Created by iLem0n on 26.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol ProductDataResponse: ParsedResponse {
    var names: [String] { get }
}
