//
//  AppCoordinator.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwiftyBeaver
import MicroBlink
import RealmSwift

let log = SwiftyBeaver.self

@UIApplicationMain
final class AppCoordinator: BaseCoordinator, UIApplicationDelegate {
    
    //-------------------- ENTRYPOINT -------------------------
    var window: UIWindow?
    var router: RouterType!
    
    private var resetFoodItemsStateToken: NotificationToken?
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let _ = NotificationManager.shared
        
        prepareLogging()
        prepareMicroblink()
        start()
    }
    
    //-------------------- PREPARATION -------------------------
    private func prepareLogging() {
        log.addDestination(ConsoleDestination())
    }
    
    private func prepareMicroblink() {
        MBMicroblinkSDK.init()
            .setLicenseKey("sRwAAAEVZGUuaWxlbTBuLmZyaWRnZXdhdGNowaMxfPvmxnXelUmmoYytIrMVHWZREw+Pb7UqUWIdnhMA43bKt2RfRapfqbsIWjCNn8o4oFlZl1waQ+UcgqsinVNDPTb1vgMVwsqAxTRnqzOzXGPNDEllPoJnXYXgOimAc0GsoozmA+fYAW6qdeFODlPu9QL4PY/1FjBQnvdokj1ydWwv/cFVtTa6BmAW")
    }
    
    //-------------------- FLOW START -------------------------
    override func start() {
        // Initialize main navigationcontroller
        let nav = UINavigationController(rootViewController: UIViewController())
        
        router = Router(rootController: nav)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        runStorageFlow()
    }
    
    //-------------------- FLOWS -------------------------
    private func runStorageFlow() {
        let coordinator = CoordinatorFactory.makeStorageCoordinator(router: router)
        
        coordinator.onScanFlowRequest = {
            self.runScanFlow()
            self.removeDependency(coordinator)
        }
        
        coordinator.onSettingsRequest = {
            self.runSettingsFlow()
            self.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runScanFlow() {
        let (coordinator, router) = CoordinatorFactory.makeScanCoordinator()
        
        coordinator.onScanFinished = {
            self.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        
        self.router.present(router)        
        coordinator.start()
    }
    
    private func runSettingsFlow() {
        let coordinator = CoordinatorFactory.makeSettingsCoordinator(router: self.router)        
        addDependency(coordinator)
        coordinator.start()
    }
}
