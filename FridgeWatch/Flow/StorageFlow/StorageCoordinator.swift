//
//  StorageCoordinator.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit

final class StorageCoordinator: BaseCoordinator, StorageCoordinatorType {

    private let router: RouterType
    private let factory: StorageModuleFactoryType
    
    var onScanFlowRequest: (() -> Void)?
    
    //  INIT
    init(router: RouterType, factory: StorageModuleFactoryType) {
        self.router = router
        self.factory = factory

        super.init()
    }

    override func start() {
        showStorageOverview()
    }
    
    private func showStorageOverview() {
        let viewModel = StorageContent_ViewModel()
        let module = factory
            .makeContentModule(viewModel: viewModel)
            { (tableController) in
            
                tableController.onConsumeItemButtonTouched = { [weak self] indexPath in
                    guard let strong = self, let item = viewModel.item(at: indexPath) else { return }
                   
                    strong.router.present(
                        strong.factory.makeGetAmountSliderModul(title: "Consume", message: "How much do you want to consume?", maxAmount: item.availableAmount, onConfirm: { (consumeAmount) in
                            viewModel.consume(at: indexPath, amount: consumeAmount)
                        })
                    )
                }
                
                tableController.onThrowAwayItemButtonTouched = { [weak self] indexPath in
                    guard let strong = self, let item = viewModel.item(at: indexPath) else { return }
                    strong.router.present(
                        strong.factory.makeGetAmountSliderModul(title: "Throw away", message: "How much do you want to throw away?", maxAmount: item.availableAmount, onConfirm: { (throwAwayAmount) in
                            viewModel.throwAway(at: indexPath, amount: throwAwayAmount)
                        })
                    )
                }
                
                tableController.onItemSelected = { [weak self] indexPath in
                    guard let item = viewModel.item(at: indexPath) else { return }
                    self?.showItemDetail(for: item)
                }
            }
        
        module?.onStartScanButtonTouched = { [weak self] in
            self?.onScanFlowRequest?()            
        }
        
        router.setRootModule(module, hideBar: true)
    }
    
    private func showItemDetail(for item: FoodItem) {
        let viewModel = ItemDetail_ViewModel(item: item)
        let module = factory.makeItemDetailModule(viewModel: viewModel) { [weak self] (tableController) in
            guard let strong = self else { return }
            
            tableController.onDateCellTouched = {
                let datePickerModule = strong.factory
                    .makeDatePickerModul(
                        initialDate: item.bestBeforeDate,
                        onApply: { (newDate) in
                            viewModel.updateDate(newDate)
                        },
                        onClear: nil,
                        onCancel: {
                        
                        }
                    )
                
                strong.router.present(datePickerModule)
            }
            
            tableController.onAmountCellTouched = {
                let getAmountModul = self?.factory
                    .makeGetAmountTextFieldModul(
                        title: "Change Amount",
                        message: "Input the new amount.",
                        initialValue: item.availableAmount,
                        onConfirm: { (newAmount) in
                            viewModel.updateAmount(newAmount)
                        }
                    )
                
                self?.router.present(getAmountModul)
            }
        }
        
        router.push(module)
    }
}
