//
//  StorageModuleFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension ModuleFactory: StorageModuleFactoryType {
    func makeContentModule(viewModel: StorageContent_ViewModelType, _ tableControllerHandler: @escaping (StorageContent_CollectionView) -> Void) -> StorageContent_View? {
        let controller = R.storyboard.storage.storageContentView()!
        controller.viewModel = viewModel
        controller.onCollectionViewSegue = { tableController in
            tableController.viewModel = viewModel
            tableControllerHandler(tableController)
        }
        return controller
    }
}
