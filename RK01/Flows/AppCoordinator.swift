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
     Add logging deestinations and log level for SwiftyBeaver-Logging
     */
    private func prepareLogging() {
        log.addDestination(ConsoleDestination())
    }
    
    /**
     Initializes the MicroBlink Framework with the licence
     */
    private func prepareMicroblink() {
        MBMicroblinkSDK.init().setLicenseKey("sRwAAAEVZGUuaWxlbTBuLmZyaWRnZXdhdGNowaMxfMXmxnXelUmmoZSuJJillToHD269Jxp0C1vPsmuECrSFmU8E8dsQkxsE4G9hpSb/sNwbpG2MMNYBMVdAmlVF7NoOr5EeQqOVhzL93zF7GY7QwjQDf8gGEFr0kBZ/Em+OzKTpszXdptr/kVQcS335ER9s1scIR6Yf9ez41Be9JmOcNT7MRom9lI384Q==")
    }
    
    /**
     Singletons which should be alloced for the whole runtime are called once to intialize
     */
    private func intializeManagers() {
        let _ = NewNotificationManager.shared
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
        
        runLoginFlow()
    }
    
    //-------------------- FLOWS -------------------------
    /**
     Start login flow
     */
    private func runLoginFlow() {
        //---- Create Coordinator ----
        let coordinator = CoordinatorFactory.makeLoginCoordinator(router: router)
        
        coordinator.onLoginSuccess = { [weak self] in
            guard let strong = self else { return }
            strong.runScanFlow(completion: { (result) in
                strong.runQuestionFlow()
            })
        }
        
        //---- Reference and start the flow -----
        addDependency(coordinator)
        coordinator.start()
    }
    
    /**
     Starts the Scan flow, which is responsible for scanning and saving new items
     */
    private func runScanFlow(completion: @escaping (String) -> Void) {
        //---- Create Coordinator and Router ----
        let (coordinator, router) = CoordinatorFactory.makeScanCoordinator()
        
        //---- Coordinator Hooks ----
        coordinator.onScanFinished = { result in
            self.removeDependency(coordinator)
            self.router.dismissModule()
            completion(result)

        }
        
        //  since the scanflow is a modal flow which uses its own router
        //  we need to present this router to the main router
        self.router.present(router)
        
        //---- Reference and start the flow -----
        coordinator.start()
        addDependency(coordinator)
    }
    
    private func runQuestionFlow() {
        log.debug(#function)
        let coordinator: QuestionCoordinatorType = CoordinatorFactory.makeQuestionCoordinator(router: router)
    
        
        //---- Reference and start the flow -----
        addDependency(coordinator)
        coordinator.start()
    }
}
