//
//  SettingsCoordinator.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

final class SettingsCoordinator: BaseCoordinator, SettingsCoordinatorType {
    private let router: RouterType
    private let factory: SettingsModuleFactoryType

    //-------------- INIT ------------------
    init(router: RouterType, factory: SettingsModuleFactoryType) {
        self.router = router
        self.factory = factory

        super.init()
    }

    override func start() {
        showMainSettingsModule()
    }

    private func showMainSettingsModule() {
        let viewModel = Settings_ViewModel()
        let modul = factory.makeMainSettingsModule(viewModel: viewModel) { [weak self] (tableController) in
            guard let strong = self else { return }
            tableController.onFeedbackCellClicked = {
                strong.showFeedbackModule()
            }
            
            tableController.onInfoCellClicked = {
                strong.showInfoModule()
            }
        }
        
        router.push(modul)
    }
    
    private func showFeedbackModule() {
        
        let email = "peter.c.glade@googlemail.com"
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "??"
        let deviceModel = UIDevice.current.modelName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let iOSVersion = UIDevice.current.systemVersion
        
        let mailtoString = "mailto:\(email)?subject=FridgeWatch%20Feedback%20%2F%20Support&body=%0A%0APlease%20do%20not%20write%20blow%20this%20line%0A------------------------------------%0AApp-Version%3A%20\(appVersion)%0AModel%3A%20\(deviceModel)%0AiOS%3A%20\(iOSVersion)"

        if let url = URL(string: mailtoString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func showInfoModule() {
        let viewModel = Info_ViewModel()
        let module = factory.makeInfoModule(viewModel: viewModel)
        
        router.push(module)
    }
}


