//
//  StorageContent_SectionModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

struct StorageContent_SectionModel {
    var header: String
    var items: [StorageContent_SectionModel.Item]
    var footer: String
}

extension StorageContent_SectionModel: SectionModelType {
    typealias Item = FoodItem
    
    init(original: StorageContent_SectionModel, items: [StorageContent_SectionModel.Item]) {
        self = original
        self.items = items
    }
}
