//
//  Info_TableController.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 20.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class Info_TableController: UITableViewController, Info_TableView {
    
    var viewModel: Info_ViewModelType?
    let disposeBag = DisposeBag()
    
    @IBOutlet var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.appVersion
            .bind(to: appVersionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.tableDataSource = RxTableViewSectionedReloadDataSource(configureCell: { (source, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.licenceCell, for: indexPath)!
            cell.configureFor(license: item)            
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
                guard let next = $0.element, let license = viewModel.item(at: next), let url = URL(string: license.link) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .disposed(by: disposeBag)
    }
}
