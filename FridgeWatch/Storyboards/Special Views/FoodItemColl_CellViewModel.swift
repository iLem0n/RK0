//
//  FoodItemColl_CellViewModel.swift
//  FridgeWatch
//
//  Created by iLem0n on 08.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class FoodItemColl_CellViewModel: NSObject, FoodItemColl_CellViewModelType {

    private let disposeBag = DisposeBag()
    let editingModeObservable: Observable<BulkEditingMode>
    
    private let itemSubject: BehaviorSubject<FoodItem>
    private let productObservable: Observable<Product>
    
    
    lazy var amount: Observable<Int> = self.itemSubject.map({ $0.availableAmount }).asObservable()
    lazy var productName: Observable<String> = self.productObservable.map({ $0.name ?? $0.gtin }).asObservable()
    lazy var productImage: Observable<UIImage> = self.productObservable.map({ $0.image ?? #imageLiteral(resourceName: "placeholer") }).asObservable()
    lazy var bestBeforeDate: Observable<Date> = self.itemSubject.map({ $0.bestBeforeDate }).asObservable()

    let editedAmount = BehaviorSubject<Int>(value: 0)
    
    init(item: FoodItem, editingModeObservable: Observable<BulkEditingMode>, onAmountEditing: @escaping (Int) -> Void) {
        
        self.editingModeObservable = editingModeObservable
        self.itemSubject = BehaviorSubject<FoodItem>(value: item)
        self.productObservable = item.productObservable
        
        super.init()
        
        self.editingModeObservable
            .filter { $0 == .none }
            .subscribe { [weak self] _ in
                self?.editedAmount.onNext(0)
            }
            .disposed(by: disposeBag)

        editedAmount
            .skip(1)
            .subscribe {
                guard let next = $0.element else { return }
                onAmountEditing(next)
            }
            .disposed(by: disposeBag)
    }
    
    func selectAllToEdit() {
        guard let item = try? itemSubject.value() else { return }
        editedAmount.onNext(item.availableAmount)
    }
}
