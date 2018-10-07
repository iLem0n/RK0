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
    
    lazy var sections: Observable<[StorageContent_SectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[StorageContent_SectionModel]>(value: [])
 
    var collectionDataSource: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>!
    
    private var updateFoodItemsToken: NotificationToken?
    
    //-------------------- LIFECIRCLE -------------------------
    override init() {
        super.init()
        self.loadData()
    }
    
    //-------------------- LOAD DATA -------------------------
    private func loadData() {
        
        self.updateFoodItemsToken = Realms.local
            .objects(FoodItem.self)
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
    
    //-------------------- ACCESSORS -------------------------
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
        let redItems = items
            .filter({ $0.bestBeforeDate.isWithin(days: 3) })
        
        let yellowItems = items
            .filter({ !redItems.contains($0) })
            .filter({ $0.bestBeforeDate.isWithin(days: 7) })
        
        for item in items {
            guard !redItems.contains(item), !yellowItems.contains(item) else { continue }
            
            let monthKey = MonthKey(date: item.bestBeforeDate)
            if dict.keys.contains(monthKey) {
                dict[monthKey]?.append(item)
            } else {
                dict[monthKey] = [item]
            }
        }
        
        var result: [StorageContent_SectionModel] = []
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
