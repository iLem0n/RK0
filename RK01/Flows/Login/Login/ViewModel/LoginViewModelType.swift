//
//  LoginViewModelType.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift

protocol LoginViewModelType: ViewModelType {
    var username: BehaviorSubject<String?> { get }
    var password: BehaviorSubject<String?> { get }
}
