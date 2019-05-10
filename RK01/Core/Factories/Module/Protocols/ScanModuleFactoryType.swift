//
//  ScanModuleFactoryType.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

protocol ScanModuleFactoryType: ModulFactoryType {
    func makeScanNavigationRouter() -> UINavigationController 
    
    func makeScanModule(
        viewModel: ScanViewModelType,
        _ cameraControllerHandler: @escaping (Scan_CameraView) -> Void)
    -> ScanView
    
    func makeReadFotoModule(viewModel: ReadFotoViewModelType) -> ReadFotoView 
}
