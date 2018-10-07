//
//  ItemDetail_ViewModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RxDataSources

class ItemDetail_ViewModel: NSObject, ItemDetail_ViewModelType, DatePickerViewModelType {
    
    let message = PublishSubject<Message>()
    let disposeBag = DisposeBag()

    lazy var item = self.itemSubject.asObservable()
    internal let itemSubject: BehaviorSubject<FoodItem>

    required init(item: FoodItem) {
        itemSubject = BehaviorSubject<FoodItem>(value: item)
    }
    
    var pickerInitialDate: Date? {
        guard let itemValue = try? itemSubject.value() else { return Date() }
        return itemValue.bestBeforeDate
    }
    
    var onDatePicked: ((Date?) -> Void)? {
        return { [weak self] newDate in
            guard let strong = self, let date = newDate, let itemValue = try? strong.itemSubject.value() else { return }
            
            let realm = Realms.local
            try? realm.write {
                itemValue.bestBeforeDate = date
            }
        }
    }
}



