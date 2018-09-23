//
//  StorageContent_TableController.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit

final class StorageContent_TableController: UITableViewController, StorageContent_TableView {
    
    //-------------------- PREPARATION -------------------------
    var viewModel: StorageContent_ViewModelType?
    let disposeBag = DisposeBag()
    
    //-------------------- INITIALISATION -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    //-------------------- VIEW MODEL LINKING -------------------------
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.tableDataSource.configureCell = { (source, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.foodItemCell, for: indexPath)!
            cell.item = item
            cell.delegate = self
            return cell
        }
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions: [SwipeAction] = []
        switch orientation {
        case .left: break
        case .right:
            actions.append(SwipeAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                self.viewModel?.delete(at: indexPath)
            }))
        }
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        switch orientation {
        case .left: break
        case .right:
            options.expansionStyle = .destructive(automaticallyDelete: false)
        }
        return options
    }
}
