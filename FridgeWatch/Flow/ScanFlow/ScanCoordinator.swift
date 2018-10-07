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
    internal let factory: ScanModuleFactoryType

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
            self?.showScanResultsModules(viewModel: viewModel)
        }
        
        module?.onBBDButtonTouched = { date in
            let datePickerModul = self.factory.makeDatePickerModul(
                viewModel: viewModel,
                onCompleted: {
                    self.router.dismissTopModule()
                }
            )
            self.router.present(datePickerModul)
        }

        
        module?.onCloseButtonTouched = { [weak self] in
            guard let strong = self else { return }
            let haveScannedItems = (try! viewModel.scannedItemsSubject.value()).count > 0
            if haveScannedItems {
                let alert = strong.factory.makeConfirmMessage(
                    title: "Confirm Close",
                    message: "You have unsaved items in your scan history. Would you like dicard?", { (shouldClose) in
                        guard shouldClose else { return }
                        strong.router.dismissModule(animated: true, completion: {
                            strong.onScanFinished?()
                        })
                    })
                
                strong.router.present(alert)
                
            } else {
                strong.router.dismissModule(animated: true, completion: {
                    strong.onScanFinished?()
                })
            }
        }
        
        router.setRootModule(module, hideBar: true, animated: false)        
    }
    
    private func showScanResultsModules(viewModel: ScanResults_ViewModelType) {
        let module = factory.makeScanResultsModule(viewModel: viewModel) { (tableController) in
            tableController.onItemSelected = { [weak self] indexPath in
                guard let item = viewModel.item(at: indexPath) else { return }
                self?.showItemDetail(for: item, onItemUpdate: { (new) in
                    viewModel.updateItem(old: item, new: new)
                })
            }
        }
        
        module?.onSaved = { [weak self] in 
            self?.router.dismissModule(animated: true, completion: {
                self?.onScanFinished?()
            })
        }
        
        router.push(module, animated: true, hideBar: false)
    }
    
    private func showItemDetail(for item: FoodItem, onItemUpdate: @escaping (FoodItem) -> Void) {
        let viewModel = TemporaryItemDetail_ViewModel(item: item)
        viewModel.item
            .subscribe {
                guard let next = $0.element else { return }
                onItemUpdate(next)
            }
            .disposed(by: viewModel.disposeBag)
        
        let module = factory.makeItemDetailModule(viewModel: viewModel) { (tableController) in
            
            tableController.onDateCellTouched = { [weak self] in
                self?.router.present(
                    self?.factory.makeDatePickerModul(viewModel: viewModel, onCompleted: {})
                )
            }
        }
        
        router.push(module)
    }
}
