//
//  Settings_ViewModelType.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxDataSources

protocol Settings_ViewModelType: ViewModelType {
    var sections: Observable<[Settings_SectionModel]> { get }
    var tableDataSource: RxTableViewSectionedReloadDataSource<Settings_SectionModel>! { get set }
    
    func item(at indexPath: IndexPath) -> Settings_SectionModel.Item?
}
