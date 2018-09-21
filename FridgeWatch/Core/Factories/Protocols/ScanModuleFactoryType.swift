//
//  ScanModuleFactoryType.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

protocol ScanModuleFactoryType {
    func makeScanNavigationRouter() -> UINavigationController 
    
    func makeScanModule(
        viewModel: Scan_ViewModelType,
        _ cameraControllerHandler: @escaping (Scan_CameraView) -> Void)
    -> Scan_View?
    
    func makeScanResultsModule(
        viewModel: ScanResults_ViewModelType,
        _ tableControllerHandler: @escaping (ScanResults_TableView) -> Void)
    -> ScanResults_View?
}
