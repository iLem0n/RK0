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
import SwipeCellKit

final class ScanResults_TableController: UITableViewController, ScanResults_TableView {
    
    var viewModel: ScanResults_ViewModelType?
    let disposeBag = DisposeBag()
    
    var onItemSelected: ((IndexPath) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.results_tableDataSource = RxTableViewSectionedReloadDataSource<ScanResults_SectionModel>(configureCell: { (source, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.foodItemCell, for: indexPath)!
            cell.item = item
            return cell
        })
        
        viewModel.results_tableDataSource.titleForHeaderInSection = { (source, section) in
            return source.sectionModels[section].header
        }
        
        viewModel.results_tableDataSource.titleForFooterInSection = { (source, section) in
            return source.sectionModels[section].footer
        }
        
        viewModel.results_sections
            .bind(to: tableView.rx.items(dataSource: viewModel.results_tableDataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe {
                guard let next = $0.element else { return }
                self.onItemSelected?(next)
                //<#Handle Selection#>
            }
            .disposed(by: disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var actions: [SwipeAction] = []
        switch orientation {
        case .left: break
        case .right:
            let removeFromListAction = SwipeAction(style: .destructive, title: "Remove", handler: { [weak self] (action, indexPath) in
                guard let strong = self else { return }
                strong.viewModel?.removeItem(at: indexPath)
            })
            removeFromListAction.image = #imageLiteral(resourceName: "trashSmall")
            actions.append(removeFromListAction)
        }
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        switch orientation {
        case .left:
            options.expansionStyle = .destructive(automaticallyDelete: false)
        case .right:
            options.expansionStyle = .destructive(automaticallyDelete: false)
        }
        return options
    }
}
