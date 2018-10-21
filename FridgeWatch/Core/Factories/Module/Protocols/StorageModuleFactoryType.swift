//
//  StorageModuleFactoryType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

protocol StorageModuleFactoryType: ModulFactoryType, SharedFactoryType {
    func makeContentModule(
        viewModel: StorageContent_ViewModelType,
        _ tableControllerHandler: @escaping (StorageContent_CollectionView) -> Void)
    -> StorageContent_View
}
