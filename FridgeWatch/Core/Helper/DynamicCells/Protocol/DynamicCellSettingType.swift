//
//  EditingCellSettingType.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 20.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift

protocol DynamicCellSettingIdentifier {}
protocol DynamicCellSettingType {
    var identifier: DynamicCellSettingIdentifier { get }
}
