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
                        strong.factory.makeGetAmountModul(
                            title: "Consume",
                            message: "How much do you want to consume?",
                            maxItemsCount: item.availableAmount,
                            onCompleted: { (consumeAmount) in
                                viewModel.consume(at: indexPath, amount: consumeAmount)
                        })
                    )
                }
                
                tableController.onThrowAwayItemButtonTouched = { [weak self] indexPath in
                    guard let strong = self, let item = viewModel.item(at: indexPath) else { return }
                    strong.router.present(
                        strong.factory.makeGetAmountModul(
                            title: "Throw away",
                            message: "How much do you want to throw away?",
                            maxItemsCount: item.availableAmount,
                            onCompleted: { (throwAwayAmount) in
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
