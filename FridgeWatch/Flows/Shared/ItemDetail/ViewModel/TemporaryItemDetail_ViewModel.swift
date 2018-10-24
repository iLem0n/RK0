//
//  TemporaryItemDetail_ViewModel.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol TemporaryItemDetail_ViewModelType: ItemDetail_ViewModelType {
    var item: Observable<FoodItem> { get }
}

final class TemporaryItemDetail_ViewModel: ItemDetail_ViewModel {
    private var productUpdateToken: NotificationToken?

    override func linkObjectChanges() {
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
    
    //  prevent subscribing to object changes because we have no realm managed object
    override func linkChanges(of item: FoodItem) {}
    
    override func linkChanges(of product: Product) {
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
    
    lazy var item: Observable<FoodItem> = self.itemSubject.asObservable()
    
    override func updateDate(_ date: Date) {
        guard let itemValue = try? self.itemSubject.value() else { return }
        let changedItem = FoodItem(bestBeforeDate: date, productID: itemValue.productID, amount: itemValue.amount)
        self.itemSubject.onNext(changedItem)
    }
    
    override func updateAmount(_ amount: Int) {
        guard let itemValue = try? self.itemSubject.value() else { return }
        let changedItem = FoodItem(bestBeforeDate: itemValue.bestBeforeDate, productID: itemValue.productID, amount: amount + itemValue.consumed + itemValue.thrownAway)
        self.itemSubject.onNext(changedItem)
    }
}
