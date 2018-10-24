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
    
    ///  called when we want to scan new products
    var onScanFlowRequest: (() -> Void)?
    
    ///  called when we need the settings flow
    var onSettingsRequest: (() -> Void)?
    
    /**
     Initializes the Coordinator
     
     - parameter router: The router which will navigate the flow
     - parameter factory: the corresponding flow factory
     */
    init(router: RouterType, factory: StorageModuleFactoryType) {
        self.router = router
        self.factory = factory
        
        super.init()
    }
    
    /**
     Coordinator entry point which starts the whole flow
     */
    override func start() {
        showStorageOverview()
    }
    
    //----------------------------------------------
    //               STORAGE OVERVIEW
    //----------------------------------------------
    
    /**
     Sets the Storage Overview Module as Root Module on the router.
     This Module shows all available items sorted by best before date
    */
    private func showStorageOverview() {

        //--------- PREPARE MODULE ------------
        let viewModel = StorageContent_ViewModel()
        let module = factory.makeContentModule(viewModel: viewModel) { (tableController) in
            
            //------- Controller Hooks ------
            //  Consume
            tableController.onConsumeItemButtonTouched = { [weak self] indexPath in
                
                guard let strong = self,
                    let item = viewModel.item(at: indexPath)    //  Get item to consume
                else { return }
                
                //  present the amount change alert view
                strong.router.present(
                    strong.factory.makeGetAmountSliderModul(
                        title: "Consume",
                        message: "How much do you want to consume?",
                        maxAmount: item.availableAmount,
                        onConfirm: { (consumeAmount) in
                            //  On Confirm -> consume given amount
                            viewModel.consume(at: indexPath, amount: consumeAmount)
                        }
                    )
                )
            }
            
            //  Throw away
            tableController.onThrowAwayItemButtonTouched = { [weak self] indexPath in
                guard let strong = self,
                    let item = viewModel.item(at: indexPath)    //  Get item to throw away
                else { return }
                
                //  present the amount change alert view
                strong.router.present(
                    strong.factory.makeGetAmountSliderModul(
                        title: "Throw away",
                        message: "How much do you want to throw away?",
                        maxAmount: item.availableAmount,
                        onConfirm: { (throwAwayAmount) in
                            //  On Confirm -> thorw away given amount
                            viewModel.throwAway(at: indexPath, amount: throwAwayAmount)
                    })
                )
            }
            
            //  Item selected -> show item details
            tableController.onItemSelected = { [weak self] indexPath in
                guard let item = viewModel.item(at: indexPath) else { return }
                self?.showItemDetail(for: item)
            }
        }
        
        //  Show Scan Controller
        module.onStartScanButtonTouched = { [weak self] in
            self?.onScanFlowRequest?()
        }
        
        //  Show Settings Controller
        module.onSettingsButtonTouched = { [weak self] in
            self?.onSettingsRequest?()
        }
        
        //--------- SHOW MODULE ------------
        router.setRootModule(module, hideBar: true)
    }
    
    
    //----------------------------------------------
    //               ITEM DETAIL
    //----------------------------------------------
    /**
     Pushes the Item Detailview to the router, where you can view adn edit detailed informations such as photos, available amount, best before date etc.
     
     - parameter item: The item to show
    */
    private func showItemDetail(for item: FoodItem) {
        //--------- PREPARE MODULE -----------
        let viewModel = ItemDetail_ViewModel(item: item)
        let module = factory.makeItemDetailModule(viewModel: viewModel) { [weak self] (tableController) in
            guard let strong = self else { return }
            
            //  Show Date Selector
            tableController.onDateCellTouched = {
                let datePickerModule = strong.factory.makeDatePickerModul(
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
            
            //  Show Amount Request Alert (Textfield)
            tableController.onAmountCellTouched = {
                let getAmountModul = self?.factory.makeGetAmountTextFieldModul(
                    title: "Change Amount",
                    message: "Input the new amount.",
                    initialValue: item.availableAmount,
                    onConfirm: { (newAmount) in
                        viewModel.updateAmount(newAmount)
                    }
                )
                
                self?.router.present(getAmountModul)
            }
            
            //  Show Image Selector Sheet
            tableController.onChangeImageButtonTouched = {
                self?.showImagePicker({
                    guard let image = $0 else { return }
                    viewModel.updateProductImage(image)
                })
            }
        }
        
        //--------- SHOW MODULE ------------
        router.push(module)
    }
    
    //----------------------------------------------
    //               IMAGE PICKER
    //----------------------------------------------
    
    //  keep reference of the selector inline delegate, otherwise it will be dealloced before we can use ist
    private var photoSelectionDelegate: InlineImagePickerDelegate?
    
    /**
     Presents the Image Picker Modul which let you choose an image either from local photo library or directly from camera
     
     - Parameter completion: a closure which is called after picking an image
     - Parameter imageOrNil: the image which was pciked or nil if canceled by user
    */
    private func showImagePicker(_ completion: @escaping (_ imageOrNil: UIImage?) -> Void) {
        //  Initialize alert
        let alert = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        
        //  inline photo delegate maps the UIImagePickerDelegate, so we dont need to add conformance to all our coordinators which want to call the image selector
        photoSelectionDelegate = InlineImagePickerDelegate(onApply: { (image) in
            //  return the selected image
            completion(image)
            
            // cleanup and dismiss
            self.photoSelectionDelegate = nil
            self.router.dismissModule()
            
        }, onCancel: {
            //  return nil since the user has canceled
            completion(nil)
            
            // cleanup and dismiss
            self.photoSelectionDelegate = nil
            self.router.dismissModule()
        })
        
        //  Capture Photo Action
        alert.addAction(UIAlertAction(title: "Capture Photo", style: .default, handler: { [weak self] (_) in
            guard let strong = self else { return }
            
            let module = strong.factory.makeImagePicker(sourceType: .camera, inlineDelegate: strong.photoSelectionDelegate!)
            strong.router.present(module)
        }))
        
        //  Choose from Photo Library Action
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (_) in
            guard let strong = self else { return }
            let module = strong.factory.makeImagePicker(sourceType: .photoLibrary, inlineDelegate: strong.photoSelectionDelegate!)
            strong.router.present(module)
        }))
        
        //  Cancel Action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (_) in
            guard let strong = self else { return }
            strong.router.dismissModule()
        }))
        
        //--------- SHOW MODULE ------------
        self.router.present(alert)
    }
}


