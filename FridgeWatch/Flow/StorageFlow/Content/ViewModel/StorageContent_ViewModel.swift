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
        self.updateFoodItemsToken = Realms.local
            .objects(FoodItem.self)
            .filter(self.filter)
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
    }
    
    private var filter: NSPredicate {
        guard let searchText = try? searchText.value(), !searchText.isEmpty else { return NSPredicate(value: true) }
        return NSPredicate(format: "product.name CONTAINS[cd] %@", searchText)
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
    
    //  Perfomr
    func performChange(_ change: BulkChangeItem) {
        DispatchQueue.global(qos: .background).async {
            let realm = Realms.local
            guard let item = realm.object(ofType: FoodItem.self, forPrimaryKey: change.itemID) else { return }
            switch change.action {
            case .consume(let amount):
                try? realm.write {
                    item.consumed += amount
                }
            case .throwAway(let amount):
                try? realm.write {
                    item.thrownAway += amount
                }
            }
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
        do {
            let realm = Realms.local
            try realm.write {
                item.consumed += amount
            }
        } catch {
            message.onNext(Message(type: .error, title: "Consume failed.", message: error.localizedDescription))
        }
    }
    
    func throwAway(at indexPath: IndexPath, amount: Int) {
        guard let item = item(at: indexPath) else { return }
        do {
            let realm = Realms.local
            try realm.write {
                item.thrownAway += amount
            }
        } catch {
            message.onNext(Message(type: .error, title: "ThrowAway failed.", message: error.localizedDescription))
        }
    }
    
    func sectionHeader(for section: Int) -> String? {
        guard
            let sections = try? sectionsSubject.value(),
            section < sections.count
        else { return nil }
        
        return sections[section].header
    }
    
    private func sections(for items: [FoodItem]) -> [StorageContent_SectionModel] {
        let innerSort: (FoodItem, FoodItem) -> Bool = { $0.bestBeforeDate < $1.bestBeforeDate }
        
        var dict: [MonthKey: [FoodItem]] = [:]
        let overdueItems = items
            .filter({ !$0.bestBeforeDate.isSameDay(Date()) && $0.bestBeforeDate < Date() })
        
        let redItems = items
            .filter({ $0.bestBeforeDate.isWithin(days: 3) })
        
        let yellowItems = items
            .filter({ !redItems.contains($0) })
            .filter({ $0.bestBeforeDate.isWithin(days: 7) })
        
        for item in items {
            guard !overdueItems.contains(item), !redItems.contains(item), !yellowItems.contains(item) else { continue }
            
            let monthKey = MonthKey(date: item.bestBeforeDate)
            if dict.keys.contains(monthKey) {
                dict[monthKey]?.append(item)
            } else {
                dict[monthKey] = [item]
            }
        }
        
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
        
        result.append(contentsOf: dict
            .keys
            .sorted { $0 < $1 }
            .map { key in
                var cal = Calendar(identifier: .gregorian)
                cal.locale = Locale.current
                let monthSymbol = cal.monthSymbols[key.month - 1]
                let monthItems = dict[key]!.sorted { $0.bestBeforeDate.day < $1.bestBeforeDate.day }
                var footer: String = ""
                if monthItems.count == 0 {
                    footer = "No items found. Either you filter is to restrictive or there are no items, yet."
                }
                return StorageContent_SectionModel(header: "\(monthSymbol) \(key.year)", items: monthItems.sorted(by: innerSort), footer: footer)
        })
        
        return result
    }
}
