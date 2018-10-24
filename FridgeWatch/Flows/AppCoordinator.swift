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

//  global accessible instance for logging (called like 'log.debug("Some awesome debug message")')
let log = SwiftyBeaver.self

@UIApplicationMain
final class AppCoordinator: BaseCoordinator, UIApplicationDelegate {
    
    //-------------------- ENTRYPOINT -------------------------
    var window: UIWindow?
    var router: RouterType!
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        prepareLogging()
        prepareMicroblink()
        
        intializeManagers()
        
        start()
    }
    
    //-------------------- PREPARATION -------------------------
    /**
     Add logging deestinations and log lebvel for SwiftyBeaver-Logging
     */
    private func prepareLogging() {
        log.addDestination(ConsoleDestination())
    }
    
    /**
     Initializes the MicroBlink Framework with the licence
     */
    private func prepareMicroblink() {
        MBMicroblinkSDK.init().setLicenseKey("sRwAAAEVZGUuaWxlbTBuLmZyaWRnZXdhdGNowaMxfPvmxnXelUmmoYytIrMVHWZREw+Pb7UqUWIdnhMA43bKt2RfRapfqbsIWjCNn8o4oFlZl1waQ+UcgqsinVNDPTb1vgMVwsqAxTRnqzOzXGPNDEllPoJnXYXgOimAc0GsoozmA+fYAW6qdeFODlPu9QL4PY/1FjBQnvdokj1ydWwv/cFVtTa6BmAW")
    }
    
    /**
     Singletons which should be alloced for the whole runtime are called once to intialize
     */
    private func intializeManagers() {
        let _ = NotificationManager.shared
    }
    
    /**
     Application Entry point which starts the first flow
     */
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
    /**
     Start storage overview flow, which is responsible for showing and managing all available items
     */
    private func runStorageFlow() {
        //---- Create Coordinator ----
        let coordinator = CoordinatorFactory.makeStorageCoordinator(router: router)
        
        //---- Coordinator Hooks ----
        coordinator.onScanFlowRequest = {
            self.runScanFlow()
            self.removeDependency(coordinator)
        }
        
        coordinator.onSettingsRequest = {
            self.runSettingsFlow()
            self.removeDependency(coordinator)
        }
        
        //---- Reference and start the flow -----
        addDependency(coordinator)
        coordinator.start()
    }
    
    /**
     Starts the Scan flow, which is responsible for scanning and saving new items
     */
    private func runScanFlow() {
        //---- Create Coordinator and Router ----
        let (coordinator, router) = CoordinatorFactory.makeScanCoordinator()
        
        //---- Coordinator Hooks ----
        coordinator.onScanFinished = {
            self.removeDependency(coordinator)
        }
        
        //  since the scanflow is a modal flow which uses its own router
        //  we need to present this router to the main router
        self.router.present(router)
        
        //---- Reference and start the flow -----
        coordinator.start()
        addDependency(coordinator)
    }
    
    /**
     Starts the settings flow, which is responsible for all user settings
     */
    private func runSettingsFlow() {
        //---- Create Coordinator ----
        let coordinator = CoordinatorFactory.makeSettingsCoordinator(router: self.router)
        
        //---- Coordinator Hooks ----
        addDependency(coordinator)
        coordinator.start()
    }
}
