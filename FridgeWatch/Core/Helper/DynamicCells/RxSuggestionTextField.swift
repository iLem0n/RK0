//
//  RxSuggestionTextField.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 02.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources


struct SuggestionSectionModel {
    var items: [SuggestionSectionModel.Item]
}

extension SuggestionSectionModel: SectionModelType {
    typealias Item = String
    
    init(original: SuggestionSectionModel, items: [SuggestionSectionModel.Item]) {
        self = original
        self.items = items
    }
}

final class RxSuggestionTextField: UITextField, UITableViewDelegate {
    
    private let cellHeight: CGFloat = 40
    private var disposeBag = DisposeBag()
    private var editingDisposeBag: DisposeBag?
    private let suggestions = BehaviorSubject<[String]>(value: [])
    private let showTableView = BehaviorSubject<Bool>(value: false)

    private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private(set) var tableDataSource: RxTableViewSectionedReloadDataSource<SuggestionSectionModel>!
    var configureCell: RxTableViewSectionedReloadDataSource<SuggestionSectionModel>.ConfigureCell! {
        didSet {
            tableDataSource = RxTableViewSectionedReloadDataSource<SuggestionSectionModel>(configureCell: configureCell)
        }
    }
    
    var suggestionsHandler: (((String, @escaping (([String]) -> Void)) -> Void))? {
        didSet {
            guard let closure = suggestionsHandler else { return }
            self.rx.text
                .filter({ $0 != nil }).map({ $0! })
                .subscribe { [weak self] in
                    guard let next = $0.element, let strong = self else { return }
                    closure(next) { suggestedStrings in
                        strong.suggestions.onNext(suggestedStrings)
                    }
                }
                .disposed(by: self.disposeBag)            
        }
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame)
        self.clearButtonMode = .whileEditing
        
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 5.0
        
        tableDataSource = RxTableViewSectionedReloadDataSource<SuggestionSectionModel>(
            configureCell: { (datasource, tableView, indexPath, item) in
                var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                }
                
                cell!.textLabel?.text = item
                return cell!
            }
        )
        
        suggestions
            .map({ [SuggestionSectionModel(items: $0)] })
            .bind(to: self.tableView.rx.items(dataSource: self.tableDataSource))
            .disposed(by: disposeBag)
        
        suggestions
            .map({ CGFloat($0.count) * self.cellHeight })
            .subscribe { [weak self] in
                guard let next = $0.element, let strong = self else { return }
                strong.tableView.frame.size.height = next
                strong.tableView.frame.size.width = strong.frame.size.width
                strong.tableView.frame.origin.x = strong.frame.origin.x
                strong.tableView.frame.origin.y =
                    strong.convert(strong.frame.origin, to: nil).y + strong.frame.size.height
            }
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.editingDidBegin)
            .subscribe { [weak self] _ in
                guard let strong = self else { return }
                strong.editingDisposeBag = DisposeBag()
                strong.suggestions
                    .map({ $0.count > 0 })
                    .bind(to: strong.showTableView)
                    .disposed(by: strong.editingDisposeBag!)
            }
            .disposed(by: disposeBag)
        
        self.rx
            .controlEvent(.editingDidEnd)
            .subscribe { [weak self] _ in
                guard let strong = self else { return }
                strong.showTableView.onNext(false)
                strong.editingDisposeBag = nil
            }
            .disposed(by: disposeBag)
        
        showTableView
            .subscribe { [weak self] in
                guard let next = $0.element, let strong = self else { return }                
                if next {
                    UIApplication.shared.keyWindow?.addSubview(strong.tableView)
                    UIApplication.shared.keyWindow?.bringSubviewToFront(strong.tableView)
                } else {
                    strong.tableView.removeFromSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] in
                guard let next = $0.element,
                    let strong = self,
                    let suggestions = try? strong.suggestions.value(),
                    suggestions.count > next.row
                else { return }
                
                strong.text = suggestions[next.row]
                strong.resignFirstResponder()
                strong.showTableView.onNext(false)
            }
            .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
