//
//  StorageContent_ViewModelType.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

protocol StorageContent_ViewModelType: ViewModelType {
    var sections: Observable<[StorageContent_SectionModel]> { get }
    
    var collectionDataSource: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>! { get set }
    
    var bulkEditingMode: BehaviorSubject<BulkEditingMode> { get }
    func commitBulkChange()
    func discardBulkChange()
    
    var searchText: BehaviorSubject<String> { get }
    
    func item(at indexPath: IndexPath) -> StorageContent_SectionModel.Item?
    func consume(at indexPath: IndexPath, amount: Int)
    func throwAway(at indexPath: IndexPath, amount: Int)
    func sectionHeader(for section: Int) -> String?

    func handleBulkChangeAmountEditing(for item: FoodItem, amount: Int)
    
    var numberOfSections: Int { get }
    
    
}
