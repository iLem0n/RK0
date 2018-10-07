//
//  TemporaryItemDetail_ViewModel.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class TemporaryItemDetail_ViewModel: ItemDetail_ViewModel {
    override var onDatePicked: ((Date?) -> Void)? {
        return { newDate in
            guard let date = newDate, let itemValue = try? self.itemSubject.value() else { return }
            let changedItem = FoodItem(bestBeforeDate: date, productGTIN: itemValue.product.gtin, amount: itemValue.amount)
            self.itemSubject.onNext(changedItem)
        }
    }
}
