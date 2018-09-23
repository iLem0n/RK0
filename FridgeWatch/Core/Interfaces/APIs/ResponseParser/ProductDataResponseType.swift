//
//  ProductDataResponseType.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 21.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol ProductDataResponseType {
    var names: [String] { get }
    var brands: [String] { get }
    var imageUrls: [URL] { get }
}
