//
//  BaseCoordinator.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 07.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation

class BaseCoordinator: NSObject, CoordinatorType {
    private var childCoordinators: [CoordinatorType] = []
    
    func start() { }

    func addDependency(_ coordinator: CoordinatorType) {
        for element in childCoordinators where element === coordinator { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorType) {
        for (idx, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: idx)
            break
        }
    }
}
