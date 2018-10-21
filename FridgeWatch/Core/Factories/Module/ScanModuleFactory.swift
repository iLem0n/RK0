//
//  ScanModuleFactory.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import MicroBlink

extension ModuleFactory: ScanModuleFactoryType {
    func makeScanNavigationRouter() -> UINavigationController {
        return R.storyboard.scan.scanNavigation()!
    }
    
    func makeScanModule(viewModel: Scan_ViewModelType, _ cameraControllerHandler: @escaping (Scan_CameraView) -> Void) -> Scan_View {
        let controller = R.storyboard.scan.scanView()!
        controller.viewModel = viewModel
        controller.onCameraViewSegue = { cameraController in
            cameraController.viewModel = viewModel
            cameraControllerHandler(cameraController)
        }
        return controller
    }
    
    func makeScanResultsModule(viewModel: ScanResults_ViewModelType, _ tableControllerHandler: @escaping (ScanResults_TableView) -> Void) -> ScanResults_View {
        let controller = R.storyboard.scan.scanResultsView()!
        controller.viewModel = viewModel
        controller.onTableViewSegue = { tableController in
            tableController.viewModel = viewModel
            tableControllerHandler(tableController)
        }
        return controller
    }
}
