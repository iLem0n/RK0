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
import RxDataSources

final class StorageContent_CollectionController: UICollectionViewController, StorageContent_CollectionView {
    
    //-------------------- PREPARATION -------------------------
    var viewModel: StorageContent_ViewModelType?
    let disposeBag = DisposeBag()
    
    //-------------------- COORDINATOR LINKS -------------------------
    var onConsumeItemButtonTouched: ((IndexPath) -> Void)?
    var onThrowAwayItemButtonTouched: ((IndexPath) -> Void)?
    var onItemSelected: ((IndexPath) -> Void)?
    
    //-------------------- INITIALISATION -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLayout()
        linkViewModel()
    }
    
    //-------------------- VIEW MODEL LINKING -------------------------
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        self.collectionView.register(R.nib.foodItem_CollCell(), forCellWithReuseIdentifier: R.reuseIdentifier.foodItemCollectionCell.identifier)
        
        viewModel.collectionDataSource = RxCollectionViewSectionedReloadDataSource<StorageContent_SectionModel>(configureCell: { (source, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.foodItemCollectionCell, for: indexPath)!
            
            cell.itemID = item.id
            cell.delegate = self
 
            return cell
        })
    
        viewModel.collectionDataSource.configureSupplementaryView = { (datasource, collectionView, header, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.foodListHeader, for: indexPath)!
            header.textLabel.text = viewModel.sectionHeader(for: indexPath.section)
            return header
        }

        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: viewModel.collectionDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                self?.onItemSelected?(next)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    //-------------------- COLLECTION VIEW -------------------------
    private func prepareLayout() {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize.width = (self.view.bounds.width / 3) - 10
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.minimumLineSpacing = 10
            
            flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 30, right: 8)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions: [SwipeAction] = []
        switch orientation {
        case .left:
            let consumeAction = SwipeAction(style: .default, title: "Consume", handler: { [weak self] (action, indexPath) in
                guard let strong = self, let item = strong.viewModel?.item(at: indexPath) else { return }
                switch item.availableAmount {
                case 1:
                    strong.viewModel?.consume(at: indexPath, amount: 1)
                default:
                    strong.onConsumeItemButtonTouched?(indexPath)
                }
            })
            consumeAction.backgroundColor = UIColor.blue
            consumeAction.image = #imageLiteral(resourceName: "pacman")
            actions.append(consumeAction)
        case .right:
            let throwAwayAction = SwipeAction(style: .destructive, title: "Thrown Away", handler: { [weak self] (action, indexPath) in
                guard let strong = self, let item = strong.viewModel?.item(at: indexPath) else { return }
                switch item.availableAmount {
                case 1:
                    strong.viewModel?.throwAway(at: indexPath, amount: 1)
                default:
                    strong.onThrowAwayItemButtonTouched?(indexPath)
                }
            })
            throwAwayAction.image = #imageLiteral(resourceName: "trash")
            actions.append(throwAwayAction)
        }
        return actions
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
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
