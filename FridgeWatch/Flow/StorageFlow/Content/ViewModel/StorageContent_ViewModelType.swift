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
    
    var tableDataSource: RxTableViewSectionedReloadDataSource<StorageContent_SectionModel> { get }
    var configureCell: RxTableViewSectionedReloadDataSource<StorageContent_SectionModel>.ConfigureCell! { get set }
    
    func item(at indexPath: IndexPath) -> StorageContent_SectionModel.Item?
}
