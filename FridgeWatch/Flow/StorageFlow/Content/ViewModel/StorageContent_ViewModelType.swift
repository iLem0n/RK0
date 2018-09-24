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
    
    var collectionDataSource: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel> { get }
    var configureCell: RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>.ConfigureCell! { get set }
    
    func item(at indexPath: IndexPath) -> StorageContent_SectionModel.Item?
    func delete(at indexPath: IndexPath)
}
