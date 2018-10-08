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
    var onScanFinished: (() -> Void)?
    
    //-------------- INIT ------------------
    init(factory: ScanModuleFactoryType) {
        self.factory = factory
        self.navigationController = factory.makeScanNavigationRouter()
        self.router = Router(rootController: self.navigationController!)
        super.init()
    }
    
    
    //-------------- START -----------------
    override func start() {        
        showScanModule()
    }
    
    
    //-------------- MODULES ---------------
    //-------------- SCAN MODULE -----------
    private func showScanModule() {
        let viewModel = Scan_ViewModel()
        let module = factory.makeScanModule(viewModel: viewModel) { (cameraController) in
            
        }
        
        module?.onResultsListButtonTouched = { [weak self] in
            self?.showScanResultsModules(viewModel: viewModel)
        }
        
        module?.onBBDButtonTouched = { date in
            let datePickerModul = self.factory
                .makeDatePickerModul(
                    initialDate: date ?? Date(),
                    onApply: { (newDate) in
                        viewModel.dateSubject.onNext(newDate)
                    },
                    onClear: {
                        viewModel.dateSubject.onNext(nil)
                    },
                    onCancel: {
                        
                    }
            )
            self.router.present(datePickerModul)
        }

        
        module?.onCloseButtonTouched = { [weak self] in
            guard let strong = self else { return }
            let haveScannedItems = (try! viewModel.scannedItemsSubject.value()).count > 0
            if haveScannedItems {
                let alert = strong.factory.makeConfirmDiscardScanResults(onReview: {                    
                    strong.showScanResultsModules(viewModel: viewModel)
                }, onDiscard: {
                    strong.router.dismissModule(animated: true, completion: {
                        strong.onScanFinished?()
                    })
                }, onCancel: {
                    strong.router.dismissModule()
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
    
    //-------------- SCAN RESULTS MODULE -----------
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
    
    //-------------- ITEM DETAIL MODULE -----------
    private func showItemDetail(for item: FoodItem, onItemUpdate: @escaping (FoodItem) -> Void) {
        //  Initialize Model
        let viewModel = TemporaryItemDetail_ViewModel(item: item)
        
        //  since we dont have items managed by realm
        //  we have to care about updates by retrieving a new item on every change
        viewModel.item
            .subscribe {
                guard let next = $0.element else { return }
                onItemUpdate(next)
            }
            .disposed(by: viewModel.disposeBag)
        
        //  Initialize Module
        let module = factory.makeItemDetailModule(viewModel: viewModel) { [weak self] (tableController) in
            guard let strong = self else { return }
            
            //  Change Date
            tableController.onDateCellTouched = {
                let datePickerModul = strong.factory
                    .makeDatePickerModul(
                        initialDate: item.bestBeforeDate,
                        onApply: { (newDate) in
                            viewModel.updateDate(newDate)
                        },
                        onClear: nil,
                        onCancel: { })
                strong.router.present(datePickerModul)
            }
            
            //  Change Amount
            tableController.onAmountCellTouched = {
                let getAmountModul = strong.factory
                    .makeGetAmountTextFieldModul(
                        title: "Change Amount",
                        message: "Input the new amount.",
                        initialValue: item.availableAmount,
                        onConfirm: { (newAmount) in
                            viewModel.updateAmount(newAmount)
                    }
                )
                
                strong.router.present(getAmountModul)
            }
        }
        
        //  Show Module
        router.push(module)
    }
}
