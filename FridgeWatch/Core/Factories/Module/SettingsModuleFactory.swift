//
//  SettingsModuleFactory.swift
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension ModuleFactory: SettingsModuleFactoryType {
    func makeMainSettingsModule(viewModel: Settings_ViewModelType, _ tableControllerHandler: @escaping (Settings_TableView) -> Void) -> Settings_View {
        let controller = R.storyboard.settings.settings_View()!
        controller.viewModel = viewModel
        controller.onTableViewSegue = { tableController in
            tableController.viewModel = viewModel
            tableControllerHandler(tableController)
        }
        return controller
    }
    
    func makeInfoModule(viewModel: Info_ViewModelType) -> Info_TableView {
        let controller = R.storyboard.settings.info_TableView()!
        controller.viewModel = viewModel
        return controller
    }
}
