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

class ItemDetail_ViewModel: NSObject, ItemDetail_ViewModelType {

    let message = PublishSubject<Message>()
    let disposeBag = DisposeBag()

    lazy var item = self.itemSubject.asObservable()
    internal let itemSubject: BehaviorSubject<FoodItem>

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
}



