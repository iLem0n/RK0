//
//  Info_ViewModelType.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 20.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

protocol Info_ViewModelType: ViewModelType {
    var appVersion: Observable<String> { get }

    var sections: Observable<[Info_SectionModel]> { get }
    
    var tableDataSource: RxTableViewSectionedReloadDataSource<Info_SectionModel>! { get  set }
        
    func item(at indexPath: IndexPath) -> Info_SectionModel.Item?
}
