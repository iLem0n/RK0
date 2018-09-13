//
//  AppCoordinator.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppCoordinator: BaseCoordinator, UIApplicationDelegate {
    
    var window: UIWindow?
    var router: RouterType!
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        start()
    }
    
    override func start() {
        // Initialize main navigationcontroller
        let nav = UINavigationController(rootViewController: UIViewController())
        nav.isNavigationBarHidden = true
        router = Router(rootController: nav)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        runStorageFlow()
    }
    
    private func runStorageFlow() {
        let coordinator = CoordinatorFactory.makeStorageCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
