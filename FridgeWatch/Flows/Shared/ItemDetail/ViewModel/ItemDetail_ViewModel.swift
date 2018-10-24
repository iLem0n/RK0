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
    
    lazy var productName = self.productSubject
        .filter({ $0 != nil }).map({ $0! })
        .map({ $0.name })
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()

    lazy var productImage = self.productSubject
        .filter({ $0 != nil }).map({ $0! })
        .map({ $0.image })
        .asObservable()
    
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
    
    internal let itemSubject: BehaviorSubject<FoodItem>
    internal let productSubject = BehaviorSubject<Product?>(value: nil)

    required init(item: FoodItem) {
        itemSubject = BehaviorSubject<FoodItem>(value: item)
        super.init()
        
        linkObjectChanges()
    }
    
    private var foodItemUpdateToken: NotificationToken?
    private var productUpdateToken: NotificationToken?
    
    func linkObjectChanges() {
        
        itemSubject
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
            
                strong.linkChanges(of: next)
                
                Stores.products.product(withID: next.productID) {
                    
                    switch $0 {
                    case .success(let product):
                        strong.productSubject.onNext(product)
                        strong.linkChanges(of: product)
                    case .failure(let error):
                        log.error(error.localizedDescription)
                    }
                }
            }
            .disposed(by: disposeBag)        
    }
    
    func linkChanges(of item: FoodItem) {
        foodItemUpdateToken = item.observe({ [weak self] in
            guard let strong = self else { return }

            switch $0 {
            case .change:   strong.itemSubject.onNext(item)
            case .deleted:  break
            case .error(let error):
                strong.message.onNext(Message(type: .error, title: "Item Update Error", message: error.localizedDescription))
            }
        })
    }
    
    func linkChanges(of product: Product) {
        productUpdateToken = product.observe({ [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .change:   strong.productSubject.onNext(product)
            case .deleted:  break
            case .error(let error):
                strong.message.onNext(Message(type: .error, title: "Product Update Error", message: error.localizedDescription))
            }
        })
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
        
        Stores.products.update(id: item.productID, { (product) in
            product.image = image
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
        }
    }
}



