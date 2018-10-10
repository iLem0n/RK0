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
    
    lazy var productName = self.itemSubject
        .map({ $0.product.name })
        .filter({ $0 != nil }).map({ $0! })
        .asObservable()
    
    lazy var productImage = self.itemSubject
        .map({ $0.product.image })
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
    private var itemID: String?

    required init(item: FoodItem) {
        itemSubject = BehaviorSubject<FoodItem>(value: item)
        super.init()
        
        linkObjectChanges()
    }
    
    private var updateToken: NotificationToken?
    func linkObjectChanges() {
        guard let itemValue = try? itemSubject.value() else { return }
        updateToken = Realms.local
            .object(ofType: FoodItem.self, forPrimaryKey: itemValue.id)?
            .observe({ [weak self] (changes) in
                self?.itemSubject.onNext(itemValue)
            })
        
        itemSubject.map({ $0.id })
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                self?.itemID = next
            }
            .disposed(by: disposeBag)
    }
    
    func updateAmount(_ amount: Int) {
        guard let itemValue = try? itemSubject.value() else { return }
        let realm = Realms.local
        try? realm.write {
            itemValue.amount = amount + itemValue.consumed  + itemValue.thrownAway
        }
    }
    
    func updateDate(_ date: Date) {
        guard let itemValue = try? itemSubject.value() else { return }
        let realm = Realms.local
        try? realm.write {
            itemValue.bestBeforeDate = date
        }
    }
    
    func updateProductImage(_ image: UIImage) {
        log.debug("ImageSize: \(image.pngData()?.count)")
        guard image.pngData()?.count ?? 0 > 16 * 1024 else {
            message.onNext(Message(type: .error, title: "Image Error", message: "Image to big."))
            return 
        }
        guard let itemID = self.itemID,
            let item = Realms.local.object(ofType: FoodItem.self, forPrimaryKey: itemID)
        else { return }
        
        let realm = Realms.shared
        try? realm.write {
            item.product.image = image
        }        
    }
}



