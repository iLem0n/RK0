//
//  ItemDetail_ViewModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RealmSwift
import RxDataSources
import UIKit

class ItemDetail_ViewModel: NSObject, ItemDetail_ViewModelType {
    let message = PublishSubject<Message>()
    let disposeBag = DisposeBag()
    
    lazy var productName = self.productNameSubject
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()
    private let productNameSubject = BehaviorSubject<String?>(value: nil)

    lazy var productImage = self.productImageSubject.asObservable()
    private let productImageSubject = BehaviorSubject<UIImage?>(value: nil)
    
    lazy var bestBeforeDate = self.itemSubject
        .map({ $0.bestBeforeDate })
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()
    
    lazy var availableAmount = self.itemSubject
        .map({ $0.availableAmount })
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()
    
    lazy var remainingDays = self.itemSubject
        .map({ Date().deltaInDays(to: $0.bestBeforeDate) })
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()
    
    
    private var itemID: String?
    internal let itemSubject: BehaviorSubject<FoodItem>
    internal let productObservable: Observable<Product>

    required init(item: FoodItem) {
        itemSubject = BehaviorSubject<FoodItem>(value: item)
        productObservable = item.productObservable
        super.init()
        
        linkObjectChanges()
    }
    
    private var foodItemUpdateToken: NotificationToken?
    private var productUpdateToken: NotificationToken?
    
    func linkObjectChanges() {
        itemSubject
            .map({ $0.id })
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                strong.itemID = next
                
                
            }
            .disposed(by: disposeBag)
        

        productObservable
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                strong.productImageSubject.onNext(next.image)
                strong.productNameSubject.onNext(next.name)
            }
            .disposed(by: disposeBag)
        
        
//        guard let itemValue = try? itemSubject.value() else { return }
//
//        foodItemUpdateToken = Realms.shared.items
//            .object(ofType: FoodItem.self, forPrimaryKey: itemValue.id)?
//            .observe({ [weak self] (changes) in
//                self?.itemSubject.onNext(itemValue)
//            })
//
//        guard let item = NewDataManager.shared.foodItem(item.id)//,
////            let product = Realms.shared.object(ofType: Product.self, forPrimaryKey: item.product.gtin)
//        else { return }
//
//        foodItemUpdateToken = item.observe { (change) in
//            log.debug("Item Data Change!")
//            switch change {
//            case .change(let changes):
//                for change in changes {
//                    switch change.name {
//                    case "bestBeforeDate":
//                        break
//                    case "amount", "consumed", "thrownAway":
//                        break
//                    default: break
//                    }
//                }
//            case .deleted: break
//            case .error(let error):
//                log.error(error.localizedDescription)
//            }
//        }
//
//        productUpdateToken = product.observe({ (change) in
//            log.debug("Product Data Change!")
//            switch change {
//            case .change(let changes):
//                for change in changes {
//                    switch change.name {
//                    case "name":
//                        self.productNameSubject.onNext(product.name)
//                    case "imageData":
//                        self.productImageSubject.onNext(product.image)
//                    default: break
//                    }
//                }
//            case .deleted: break
//            case .error(let error):
//                log.error(error.localizedDescription)
//            }
//        })
        
        
        
        itemSubject.map({ $0.id })
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                self?.itemID = next
            }
            .disposed(by: disposeBag)
    }
    
    func linkObjectChanges(on product: Product) {
    
    }
    
    func updateAmount(_ amount: Int) {
        guard let itemValue = try? itemSubject.value() else { return }
        
        Stores.items.update(id: itemValue.id, { (item) in
            item.amount = amount + item.consumed  + item.thrownAway
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
        }
    }
    
    func updateDate(_ date: Date) {
        guard let itemValue = try? itemSubject.value() else { return }
        
        Stores.items.update(id: itemValue.id, { (item) in
            item.bestBeforeDate = date
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
        }
    }
    
    func updateProductImage(_ image: UIImage) {
        guard let item = try? self.itemSubject.value() else { return }
        guard image.pngData()?.count ?? 0 > 16 * 1024 else {
            message.onNext(Message(type: .error, title: "Image Error", message: "Image to big."))
            return
        }
        
        Stores.products.update(id: item.productGTIN, { (product) in
            product.image = image
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
        }
    }
}



