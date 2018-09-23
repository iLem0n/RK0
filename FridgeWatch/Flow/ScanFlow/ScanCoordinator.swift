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
    
    var onScanFinished: (() -> Void)?
    
    private let navigationController: UINavigationController!
    let router: RouterType!
    private let factory: ScanModuleFactoryType

    //  INIT
    init(factory: ScanModuleFactoryType) {
        self.factory = factory
        self.navigationController = factory.makeScanNavigationRouter()
        self.router = Router(rootController: self.navigationController!)
        super.init()
    }

    override func start() {        
        showScanModule()
    }
    
    private func showScanModule() {
        let viewModel = Scan_ViewModel()
        let module = factory.makeScanModule(viewModel: viewModel) { (cameraController) in
            
        }
        
        module?.onResultsListButtonTouched = { [weak self] in
            guard
                let strong = self,
                let results = try? viewModel.scannedItems.value()
            else { return }
            
            strong.showScanresultsModules(results: results)
        }
        
        module?.onBBDButtonTouched = { date in
            let datePickerModul = self.factory
                .makeDatePickerModul(date: date ?? Date(),
                                     onApply: { date in
                                        viewModel.date.onNext(date)
                                        self.router.dismissTopModule()
                }, onClear: {
                    viewModel.date.onNext(nil)
                    self.router.dismissTopModule()
                }, onCancel: {
                    self.router.dismissTopModule()
                }
            )
            self.router.present(datePickerModul)
        }

        
        module?.onCloseButtonTouched = { [weak self] in
            self?.router.dismissModule(animated: true, completion: {
                self?.onScanFinished?()
            })
        }
        
        router.setRootModule(module, hideBar: true, animated: false)        
    }
    
    private func showScanresultsModules(results: [FoodItem]) {
        let viewModel = ScanResults_ViewModel(results: results)
        let module = factory.makeScanResultsModule(viewModel: viewModel) { (tableController) in
            
        }
        
        module?.onSaved = { [weak self] in 
            self?.router.dismissModule(animated: true, completion: {
                self?.onScanFinished?()
            })
        }
        
        router.push(module, animated: true, hideBar: false)
    }
}
