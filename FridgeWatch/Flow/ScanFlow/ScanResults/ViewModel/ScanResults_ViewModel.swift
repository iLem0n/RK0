//
//  ScanResultsViewModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RxDataSources
import RealmSwift

final class ScanResults_ViewModel: NSObject, ScanResults_ViewModelType {
    
    let message = PublishSubject<Message>()
    
    lazy var sections: Observable<[ScanResults_SectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[ScanResults_SectionModel]>(value: [])
 
    var tableDataSource: RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>!

    func item(at indexPath: IndexPath) -> ScanResults_SectionModel.Item? {
        guard let sections = try? self.sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
            else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
    
    init(results: [FoodItem]) {
        super.init()
        self.sectionsSubject
            .onNext(
                [ScanResults_SectionModel(header: "Scanning Results", items: results, footer: "")]
        )
    }
    
    func save(_ completion: (Bool) -> Void) {
        do {
            let objects: [FoodItem] = (try self.sectionsSubject.value()).map({ $0.items }).flatMap({ $0 })
            
            let realm = Realms.local
            try realm.write {
                realm.add(objects)
                completion(true)
            }
        } catch {
            self.message.onNext(Message(type: .error, title: "Save Error", text: error.localizedDescription))
            completion(false)
        }
    }
}
