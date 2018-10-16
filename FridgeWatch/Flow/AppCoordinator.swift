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
        prepareLogging()
        prepareMicroblink()
        start()
        
        
        ["3057640186158", "4066600614319"].forEach { (gtin) in
            Stores.products.product(withID: gtin, {                
                switch $0 {
                case .success(let product):
                    log.debug(product)
                case .failure(let error):
                    switch error {
                    case .realmError(let realmError):
                        log.debug(realmError.localizedDescription)
                    case .objectNotFound:
                        log.debug("Product \(gtin) not found.")
                    }
                }
            })
//                    
//            let itemsRealm = NewDataManager.shared.foodItemStore
//            try? itemsRealm?.write {
//                itemsRealm?.add(FoodItem(bestBeforeDate: Date(), productGTIN: gtin))
//            }
        }
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
}
