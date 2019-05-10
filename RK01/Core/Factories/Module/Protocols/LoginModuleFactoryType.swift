//
//  LoginModuleFactoryType.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import Foundation

protocol LoginModuleFactoryType {
    func makeLoginModule(viewModel: LoginViewModelType) -> LoginView
}
