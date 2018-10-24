//
//  StorageContent_ViewModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RxDataSources
import SwiftMessages
import RealmSwift

final class StorageContent_ViewModel: NSObject, StorageContent_ViewModelType {
         
    //-------------------- PREPARATION -------------------------
    let message = PublishSubject<Message>()
    private let disposeBag = DisposeBag()
    
    lazy var sections: Observable<[StorageContent_SectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[StorageContent_SectionModel]>(value: [])
 
    var collectionDataSource: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>!
    
    let searchText = BehaviorSubject<String>(value: "")
    let bulkEditingMode = BehaviorSubject<BulkEditingMode>(value: .none)
    private let bulkChangeItems = BehaviorSubject<[BulkChangeItem]>(value: [])
    
    private var updateFoodItemsToken: NotificationToken?
    
    //-------------------- LIFECIRCLE -------------------------
    override init() {
        super.init()
        linkViewModel()
        loadData()
    }
    
    private func linkViewModel() {
        searchText
            .subscribe { [weak self] _ in
                guard let strong = self else { return }
                strong.loadData()
            }
            .disposed(by: disposeBag)
    }
    
    //-------------------- LOAD DATA -------------------------
    private func loadData() {
        Stores.items.all({ [weak self] in
            guard let strong = self else { return }
            switch $0 {
            case .success(let items):
                strong.updateFoodItemsToken = items
                    .observe { [weak self] (changes) in
                        guard let strong = self else { return }
                        switch changes {
                        case .update(let objects, _, _, _),
                             .initial(let objects):
                                                        
                            strong.sectionsSubject.onNext(strong.sections(for: objects.map({ $0 }).filter({ $0.available }) ))
                            
                        case .error(let error):
                            strong.message.onNext(Message(type: .error, title: "Database Error", message: "Unable to fetch objects: \(error)"))
                        }
                }
            case .failure(let error):
                strong.message.onNext(Message(type: .error, title: "", message: error.localizedDescription))
            }
        })
        
    }

    //----------- BULKK CHANGE ---------
    //  Cell Hook
    func handleBulkChangeAmountEditing(for item: FoodItem, amount: Int) {
        guard var changeItems = try? bulkChangeItems.value(), let changeMode = try? bulkEditingMode.value(), changeMode != .none else { return }
        if let existingChange = changeItems.enumerated().filter({ $0.element.itemID == item.id }).first {
            
            let newChange: BulkChangeItem
            switch changeMode {
            case .consume:
                newChange = BulkChangeItem(itemID: item.id, action: .consume(amount))
            case .throwAway:
                newChange = BulkChangeItem(itemID: item.id, action: .throwAway(amount))
            default: return
            }
            
            changeItems[existingChange.offset] = newChange
            bulkChangeItems.onNext(changeItems)
        } else {
            let newChange: BulkChangeItem
            switch changeMode {
            case .consume:
                newChange = BulkChangeItem(itemID: item.id, action: .consume(amount))
            case .throwAway:
                newChange = BulkChangeItem(itemID: item.id, action: .throwAway(amount))
            default: return
            }
            
            changeItems.append(newChange)
            bulkChangeItems.onNext(changeItems)
        }
        
    }
    
    //  Perform
    func performChange(_ change: BulkChangeItem) {
        DispatchQueue.global(qos: .background).async {
            Stores.items.update(id: change.itemID, { (item) in
                switch change.action {
                case .consume(let amount):
                    item.consumed += amount
                case .throwAway(let amount):
                    item.thrownAway += amount
                }
            }, errorHandler: { [weak self] (error) in
                guard let strong = self else { return }
                strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
            })
        }        
    }
    
    //  Commit
    func commitBulkChange() {
        guard let changes = try? self.bulkChangeItems.value() else { return }
        changes.forEach {
            performChange($0)
        }
        discardBulkChange()
        bulkEditingMode.onNext(.none)
    }
    
    //  Discard
    func discardBulkChange() {
        bulkChangeItems.onNext([])
        bulkEditingMode.onNext(.none)
    }
    
    
    //-------------------- ACCESSORS -------------------------
    var numberOfSections: Int {
        guard let sections = try? self.sectionsSubject.value() else { return 0 }
        return sections.count
    }
    
    func item(at indexPath: IndexPath) -> StorageContent_SectionModel.Item? {
        guard let sections = try? self.sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
            else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
    
    func consume(at indexPath: IndexPath, amount: Int) {
        guard let item = item(at: indexPath) else { return }
        Stores.items.update(id: item.id, { (item) in
            item.consumed += amount
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
            
        }
    }
    
    func throwAway(at indexPath: IndexPath, amount: Int) {
        guard let item = item(at: indexPath) else { return }
        Stores.items.update(id: item.id, { (item) in
            item.thrownAway += amount
        }) { [weak self] (error) in
            guard let strong = self else { return }
            strong.message.onNext(Message(type: .error, title: "Database Error", message: error.localizedDescription))
            
        }
    }
    
    
    func sectionHeader(for section: Int) -> String? {
        guard
            let sections = try? sectionsSubject.value(),
            section < sections.count
        else { return nil }
        
        return sections[section].header
    }
    
    /**
     Arranges the given items in seperate sections based on the relative date from now.
     
     - parameter items: An array of items to arrange in sections
     - returns: An array of section models which contains the arranged items
     */
    private func sections(for items: [FoodItem]) -> [StorageContent_SectionModel] {
        
        //  inner section sorting closure
        let innerSort: (FoodItem, FoodItem) -> Bool = { $0.bestBeforeDate < $1.bestBeforeDate }
        
        //  warning sections
        //  temporary dictionary to sort the items into month
        var dict: [MonthKey: [FoodItem]] = [:]
        
        //  filter for items which date is today or in the past
        let overdueItems = items
            .filter({ !$0.bestBeforeDate!.isSameDay(Date()) && $0.bestBeforeDate < Date() })
        
        //  filter for items which will go bad within the next 3  days
        let redItems = items
            .filter({ $0.bestBeforeDate.isWithin(days: 3) })
        
        //  filter for items which will go bad within the next 7 days
        let yellowItems = items
            .filter({ !redItems.contains($0) })
            .filter({ $0.bestBeforeDate.isWithin(days: 7) })
        
        
        //  Arrange all other items by monthkey
        let allOther = items
            .filter({ !overdueItems.contains($0) })
            .filter({ !redItems.contains($0) })
            .filter({ !yellowItems.contains($0) })
        
        for item in allOther {
            let monthKey = MonthKey(date: item.bestBeforeDate)
            if dict.keys.contains(monthKey) {
                dict[monthKey]?.append(item)
            } else {
                dict[monthKey] = [item]
            }
        }
        
        //  put it all together
        var result: [StorageContent_SectionModel] = []
        if overdueItems.count > 0 {
            result.append(StorageContent_SectionModel(header: "Overdue", items: overdueItems.sorted(by: innerSort), footer: ""))
        }
        
        if redItems.count > 0 {
            result.append(StorageContent_SectionModel(header: "Next \(3) Days", items: redItems.sorted(by: innerSort), footer: ""))
        }
        
        if yellowItems.count > 0 {
            result.append(StorageContent_SectionModel(header: "Next \(7) Days", items: yellowItems.sorted(by: innerSort), footer: ""))
        }
        
        let allOthersSections = allOther
            .arrangeByMonth()
            .map({ (montkey, items) -> StorageContent_SectionModel in
                let symbol = Calendar.current.localizedMonthSymbol(montkey.month)!
                return StorageContent_SectionModel(header: "\(symbol) \(montkey.year)", items: items, footer: "")
            })
        
        result.append(contentsOf: allOthersSections)
        
        return result
    }
}

extension Calendar {
    func localizedMonthSymbol(_ month: Int) -> String? {
        guard month > 0 && month < 12 else { return nil }
        
        //  copy calendar to avoid side effects (mutating)
        var cal = self
        cal.locale = Locale.current
        
        return cal.monthSymbols[month - 1]
    }
}
