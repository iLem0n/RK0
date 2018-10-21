//
//  SettingsModuleFactoryType.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation

protocol SettingsModuleFactoryType: ModulFactoryType, SharedFactoryType {
    func makeMainSettingsModule(
        viewModel: Settings_ViewModelType,
        _ tableControllerHandler: @escaping (Settings_TableView) -> Void)
    -> Settings_View
    
    func makeInfoModule(viewModel: Info_ViewModelType) -> Info_TableView

}
