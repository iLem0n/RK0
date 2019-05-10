//
//  LoginCoordinatorType.swift
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol LoginCoordinatorType:  CoordinatorType {
    var onLoginSuccess: (() -> Void)? { get set }
}
