//
//  ScanResults_ViewModelType.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

protocol ScanResults_ViewModelType: ViewModelType {
    var results_sections: Observable<[ScanResults_SectionModel]> { get }
    var results_tableDataSource: RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>! { get set }
    
    func item(at indexPath: IndexPath) -> ScanResults_SectionModel.Item?
    func removeItem(at indexPath: IndexPath) 
    func saveScanResults(_ completion: (Bool) -> Void)
    func updateItem(old: FoodItem, new: FoodItem)
}
