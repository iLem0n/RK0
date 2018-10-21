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
import RealmSwift

final class FoodItemColl_CellViewModel: NSObject, FoodItemColl_CellViewModelType {

    private let disposeBag = DisposeBag()
    let editingModeObservable: Observable<BulkEditingMode>
    
    private let itemSubject: BehaviorSubject<FoodItem>
    private let productSubject = BehaviorSubject<Product?>(value: nil)
    
    lazy var amount: Observable<Int> = self.itemSubject.map({ $0.availableAmount }).asObservable()
    lazy var bestBeforeDate: Observable<Date> = self.itemSubject.map({ $0.bestBeforeDate }).asObservable()
    lazy var productName: Observable<String> = self.productSubject.filter({ $0 != nil }).map({ $0!.name ?? $0!.id }).asObservable()
    lazy var productImage: Observable<UIImage> = self.productSubject.filter({ $0 != nil }).map({ $0!.image ?? #imageLiteral(resourceName: "placeholer") }).asObservable()

    let editedAmount = BehaviorSubject<Int>(value: 0)
    
    private var foodItemUpdateToken: NotificationToken?
    private var productUpdateToken: NotificationToken?
    
    init(item: FoodItem, editingModeObservable: Observable<BulkEditingMode>, onAmountEditing: @escaping (Int) -> Void) {
        
        self.editingModeObservable = editingModeObservable
        self.itemSubject = BehaviorSubject<FoodItem>(value: item)
        
        super.init()

        Stores.products.product(withID: item.productID) { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let product):
                strong.productSubject.onNext(product)
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
        
        
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
            default:        break
            }
        })
    }
    
    func linkChanges(of product: Product) {
        productUpdateToken = product.observe({ [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .change:   strong.productSubject.onNext(product)
            default:        break
            }
        })
    }
    
    func selectAllToEdit() {
        guard let item = try? itemSubject.value() else { return }
        editedAmount.onNext(item.availableAmount)
    }
}
