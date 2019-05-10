//
//  LoginCoordinator.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift

final class LoginCoordinator: BaseCoordinator, LoginCoordinatorType {
    private let router: RouterType
    private let factory: LoginModuleFactoryType
    private let disposeBag = DisposeBag()
    
    var onLoginSuccess: (() -> Void)?
    
    func toPresent() -> UIViewController? {
        return router.toPresent()
    }

    //  INIT
    init(router: RouterType, factory: LoginModuleFactoryType) {
        self.router = router
        self.factory = factory

        super.init()
    }

    override func start() {
        showLoginModule()
    }
    
    //-------------- MODULES ---------------
    //-------------- SCAN MODULE -----------
    private func showLoginModule() {
        let viewModel = LoginViewModel()
        let module = factory.makeLoginModule(viewModel: viewModel)
        module.onLoginButtonClicked = { [weak self] in
            guard let strong = self else { return }
        
            if ServerConnector.MOCKUP {                
                strong.onLoginSuccess?()
            } else {
                ServerConnector.shared.sessionID
                    .filter({ $0 != nil })
                    .subscribe({ _ in
                        strong.onLoginSuccess?()
                    })
                    .disposed(by: strong.disposeBag)
                ServerConnector.shared.startSession(username: $0)
            }
        }
        router.setRootModule(module, hideBar: true, animated: false)
    }
}
