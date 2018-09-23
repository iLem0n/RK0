//
//  ScanResults_TableController.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ScanResults_TableController: UITableViewController, ScanResults_TableView {
    
    var viewModel: ScanResults_ViewModelType?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.tableDataSource = RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>(configureCell: { (source, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.foodItemCell, for: indexPath)!
            cell.item = item
            return cell
        })
        
        viewModel.tableDataSource.titleForHeaderInSection = { (source, section) in
            return source.sectionModels[section].header
        }
        
        viewModel.tableDataSource.titleForFooterInSection = { (source, section) in
            return source.sectionModels[section].footer
        }
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: viewModel.tableDataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe {
                guard let next = $0.element else { return }
                //<#Handle Selection#>
            }
            .disposed(by: disposeBag)
    }
}
