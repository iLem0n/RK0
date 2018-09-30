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
    
    private var flushProductDataToken: NotificationToken?
    func applicationDidFinishLaunching(_ application: UIApplication) {
        prepareLogging()
        prepareMicroblink()
        
        //  FLUSH ALL PRODUCT DATA
        //  TODO: Remove on PROD
//        let realm = Realms.shared
//        flushProductDataToken = realm.objects(Product.self).observe { (change) in
//            switch change {
//            case .initial(let objects), .update(let objects, _,_,_):
//                try! realm.write {
//                    objects.forEach({ (prod) in
//                        realm.delete(prod)
//                    })
//                }
//            case .error(let error):
//                log.error(error.localizedDescription)
//            }
//        }
        
        start()
    }
    
    //-------------------- PREPARATION -------------------------
    private func prepareLogging() {
        log.addDestination(ConsoleDestination())
    }
    
    private func prepareMicroblink() {
        MBMicroblinkSDK.init()
            .setLicenseKey("sRwAAAEVZGUuaWxlbTBuLmZyaWRnZXdhdGNowaMxfPvmxnXelUmmoaypIreyh4spTleVfYD1yjbuTwItHnICkkZXgxEi9EXWptEOmmNNWchPGvBy4qSD27NJYfbCfHcX3FSzAX29GjdpUxDQG7n9anFydgpFfYJuMvnm11PgRoaL+LLSYNlbNqO13HbnjP2WVhMqZ//4VPmoozcI6n691B1Cxqhpn0ZI")
    }
    
    //-------------------- FLOW START -------------------------
    override func start() {
        // Initialize main navigationcontroller
        let nav = UINavigationController(rootViewController: UIViewController())
        nav.isNavigationBarHidden = true
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
