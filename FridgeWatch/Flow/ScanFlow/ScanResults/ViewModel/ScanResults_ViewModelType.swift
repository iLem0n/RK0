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
    var sections: Observable<[ScanResults_SectionModel]> { get }
    
    var tableDataSource: RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>! { get set }
    
    func item(at indexPath: IndexPath) -> ScanResults_SectionModel.Item?
    
    init(results: [FoodItem])
    
    func save(_ completion: (Bool) -> Void)
}