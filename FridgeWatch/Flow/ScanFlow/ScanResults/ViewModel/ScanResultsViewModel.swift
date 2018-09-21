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

final class ScanResults_ViewModel: NSObject, ScanResults_ViewModelType {
    let message = PublishSubject<Message>()
    
    lazy var sections: Observable<[ScanResultsSectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[ScanResultsSectionModel]>(value: [])
        
    let tableDataSource = RxTableViewSectionedReloadDataSource<ScanResultsSectionModel>()
 
    private(set) var tableDataSource: RxTableViewSectionedReloadDataSource<ScanResultsSectionModel>!
    var configureCell: RxTableViewSectionedReloadDataSource<ScanResultsSectionModel>.ConfigureCell! {
        didSet {
            tableDataSource = RxTableViewSectionedReloadDataSource<ScanResultsSectionModel>(configureCell: configureCell)
        }
    }
    
    func item(at indexPath: IndexPath) -> ScanResultsSectionModel.Item? {
        guard let sections = try? self.sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
            else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
}
