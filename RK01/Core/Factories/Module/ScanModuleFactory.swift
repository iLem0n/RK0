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
    
    func makeScanModule(viewModel: ScanViewModelType, _ cameraControllerHandler: @escaping (Scan_CameraView) -> Void) -> ScanView {
        let controller = R.storyboard.scan.scanView()!
        controller.viewModel = viewModel
        controller.onCameraViewSegue = { cameraController in
            cameraController.viewModel = viewModel
            cameraControllerHandler(cameraController)
        }
        return controller
    }
    
    func makeReadFotoModule(viewModel: ReadFotoViewModelType) -> ReadFotoView {
        let controller = R.storyboard.scan.readFoto()!
        controller.viewModel = viewModel
        
        return controller
    }
}
