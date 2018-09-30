//
//  StorageCoordinator.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

final class StorageCoordinator: BaseCoordinator, StorageCoordinatorType {
    private let router: RouterType
    private let factory: StorageModuleFactoryType    
    
    var onScanFlowRequest: (() -> Void)?
    
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
        let viewModel = StorageContent_ViewModel()
        let module = factory
            .makeContentModule(viewModel: viewModel)
            { (tableController) in
            
            }
        
        module?.onStartScanButtonTouched = { [weak self] in
            self?.onScanFlowRequest?()
        }
        
        router.setRootModule(module)
    }
}
