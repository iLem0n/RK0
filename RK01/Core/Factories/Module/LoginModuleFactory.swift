//
//  LoginModuleFactory.swift
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation

extension ModuleFactory: LoginModuleFactoryType {
    func makeLoginModule(viewModel: LoginViewModelType) -> LoginView {
        let controller = R.storyboard.login.loginView()!
        controller.viewModel = viewModel
        return controller
    }
}
