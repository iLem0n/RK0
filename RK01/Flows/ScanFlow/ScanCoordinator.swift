//
//  ScanCoordinator.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import MicroBlink

final class ScanCoordinator: BaseCoordinator, ScanCoordinatorType {

    let router: RouterType!
    private let navigationController: UINavigationController!
    private let factory: ScanModuleFactoryType

    //-------------- COORDINATOR HOOKS -----
    var onScanFinished: ((String) -> Void)?
    
    //-------------- INIT ------------------
    init(router: Router, factory: ScanModuleFactoryType) {
        self.factory = factory
        self.navigationController = factory.makeScanNavigationRouter()
        self.router = Router(rootController: self.navigationController!)
        super.init()
    }
    
    
    //-------------- START -----------------
    override func start() {        
        showReadFotoModule()
    }
        
    //-------------- MODULES ---------------
    //-------------- SCAN MODULE -----------
    private func showScanModule() {
        let viewModel = ScanViewModel()
        let module = factory.makeScanModule(viewModel: viewModel) { (cameraController) in
            
        }
        
        module.onSendButtonClicked = { [weak self] in
            guard let strong = self else { return }
            strong.onScanFinished?($0)            
        }
                
        router.setRootModule(module, hideBar: true, animated: false)        
    }
    
    //-------------- READ FOTO MODULE -----------
    private func showReadFotoModule() {
        let viewModel = ReadFotoViewModel()
        let module = factory.makeReadFotoModule(viewModel: viewModel)
        
        router.present(module)
    }
}
