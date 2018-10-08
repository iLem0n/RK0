//
//  TemporaryItemDetail_ViewModel.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class TemporaryItemDetail_ViewModel: ItemDetail_ViewModel {
    
    //  prevent subscribing to object changes because we have no realm managed object
    override func linkObjectChanges() {}
    
    override func updateDate(_ date: Date) {
        guard let itemValue = try? self.itemSubject.value() else { return }
        let changedItem = FoodItem(bestBeforeDate: date, productGTIN: itemValue.product.gtin, amount: itemValue.amount)
        self.itemSubject.onNext(changedItem)
    }
    
    override func updateAmount(_ amount: Int) {
        guard let itemValue = try? self.itemSubject.value() else { return }
        let changedItem = FoodItem(bestBeforeDate: itemValue.bestBeforeDate, productGTIN: itemValue.product.gtin, amount: amount + itemValue.consumed + itemValue.thrownAway)
        self.itemSubject.onNext(changedItem)
    }
}
