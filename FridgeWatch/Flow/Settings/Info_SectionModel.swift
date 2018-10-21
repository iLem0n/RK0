//
//  Info_SectionModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 20.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

struct Info_SectionModel {
    var header: String
    var items: [Info_SectionModel.Item]
    var footer: String
}

extension Info_SectionModel: SectionModelType {
    typealias Item = Licenses.License
    
    init(original: Info_SectionModel, items: [Info_SectionModel.Item]) {
        self = original
        self.items = items
    }
}
