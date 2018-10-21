//
//  Settings_SectionModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

struct Settings_SectionModel {
    var header: String
    var items: [Settings_SectionModel.Item]
    var footer: String
}

extension Settings_SectionModel: SectionModelType {
    typealias Item = DynamicCellSettingType
    
    init(original: Settings_SectionModel, items: [Settings_SectionModel.Item]) {
        self = original
        self.items = items
    }
}
