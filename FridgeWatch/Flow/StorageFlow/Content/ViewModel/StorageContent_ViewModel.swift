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
 
    private(set) var collectionDataSource = RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>(configureCell:  { (_, _, _, _) -> UICollectionViewCell in
        return UICollectionViewCell(frame: .zero)
    })
    var configureCell: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>.ConfigureCell! {
        didSet {
            collectionDataSource = RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>(configureCell: configureCell)
        }
    }
    
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
            .observe { (changes) in
                switch changes {
                case .update(let objects, _, _, _),
                     .initial(let objects):                                        
                    
                    self.sectionsSubject.onNext(
                        [
                            StorageContent_SectionModel(
                                header: "Fridge",
                                items: objects.map({ $0 }),
                                footer: "")
                        ]
                    )
                case .error(let error):
                    self.message.onNext(Message(type: .error, title: "Database Error", text: "Unable to fetch objects: \(error)"))
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
    
    func delete(at indexPath: IndexPath) {
        guard let item = item(at: indexPath) else { return }
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(item)
            }
        } catch {
            message.onNext(Message(type: .error, title: "Deletion failed.", text: error.localizedDescription))
        }
    }
}
