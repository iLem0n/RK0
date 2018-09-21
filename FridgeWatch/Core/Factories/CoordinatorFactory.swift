//
//  CoordinatorFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class CoordinatorFactory: CoordinatorFactoryType {
    static func makeScanCoordinator() -> (ScanCoordinatorType, RouterType) {
        let coordinator = ScanCoordinator(factory: ModuleFactory())
        return (coordinator, coordinator.router)
    }
    
    static func makeStorageCoordinator(router: RouterType) -> StorageCoordinatorType {
        return StorageCoordinator(router: router, factory: ModuleFactory())
    }
}
