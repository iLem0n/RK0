//
//  DatePickerViewModelType.swift
//
//  FoodWatch
//
//  Created by Peter Christian Glade on 28.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift

protocol DatePickerViewModelType {
    var dateSubject: BehaviorSubject<Date?> { get }
}
