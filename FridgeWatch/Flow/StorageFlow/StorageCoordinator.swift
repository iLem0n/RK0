//
//  StorageCoordinator.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

final class StorageCoordinator: BaseCoordinator {
    private let router: RouterType
    private let factory: StorageModuleFactoryType

    //  INIT
    init(router: RouterType, factory: StorageModuleFactoryType) {
        self.router = router
        self.factory = factory

        super.init()
    }

    override func start() {
        showStorageOverview()
    }
    
    private func showStorageOverview() {
        
    }
}
