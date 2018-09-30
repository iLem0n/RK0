//
//  StorageContent_CollectionController.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit

final class StorageContent_CollectionController: UICollectionViewController, StorageContent_CollectionView {
    
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
        
        self.collectionView.register(R.nib.foodItemCollectionCell)
        
        viewModel.collectionDataSource.configureCell = { (source, tableView, indexPath, item) in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.foodItemCollectionCell, for: indexPath)!
            
            cell.itemID = item.id
            cell.delegate = self
            return cell
        }
        
//        viewModel.collectionDataSource.header.titleForHeaderInSection = { (source, section) in
//            return source.sectionModels[section].header
//        }
//        
//        viewModel.collectionDataSource.titleForFooterInSection = { (source, section) in
//            return source.sectionModels[section].footer
//        }
        
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: viewModel.collectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe {
                guard let next = $0.element else { return }
                //<#Handle Selection#>
            }
            .disposed(by: disposeBag)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
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
