//
//  ScanResults_SectionModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

struct ScanResults_SectionModel {
    var header: String
    var items: [ScanResults_SectionModel.Item]
    var footer: String
}

extension ScanResults_SectionModel: SectionModelType {
    typealias Item = FoodItem
    
    init(original: ScanResults_SectionModel, items: [ScanResults_SectionModel.Item]) {
        self = original
        self.items = items
    }
}
