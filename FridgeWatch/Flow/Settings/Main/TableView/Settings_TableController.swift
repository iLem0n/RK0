//
//  Settings_TableController.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class Settings_TableController: UITableViewController, Settings_TableView {
    
    var viewModel: Settings_ViewModelType?
    let disposeBag = DisposeBag()
    
    var onFeedbackCellClicked: (() -> Void)?
    var onInfoCellClicked: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        CellFactory.prepare(tableView: self.tableView)
        viewModel.tableDataSource = RxTableViewSectionedReloadDataSource<Settings_SectionModel>(configureCell: { (source, tableView, indexPath, item) -> UITableViewCell in
            return CellFactory.makeCell(for: tableView, setting: item, at: indexPath)
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
            .subscribe { [weak self] in
                guard let strong = self,
                    let indexPath = $0.element,
                    let setting = viewModel.item(at: indexPath)
                else { return }
                strong.tableView.deselectRow(at: indexPath, animated: true)
                strong.handleSelection(setting)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleSelection(_ setting: Settings_SectionModel.Item) {
        switch setting.identifier as! SettingsIdentifier {
        case .feedbackSupport:
            self.onFeedbackCellClicked?()
        case .info:
            self.onInfoCellClicked?()
        }
    }
}
