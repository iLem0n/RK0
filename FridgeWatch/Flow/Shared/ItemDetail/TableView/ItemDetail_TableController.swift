//
//  ItemDetail_TableController.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 06.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

final class ItemDetail_TableController: UITableViewController, ItemDetail_TableView {
    
    var viewModel: ItemDetail_ViewModelType?
    let disposeBag = DisposeBag()

    var onAmountCellTouched: (() -> Void)?
    var onImageViewTouched: (() -> Void)?
    var onDateCellTouched: (() -> Void)?
    
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var bestBeforeDateLabel: UILabel!
    @IBOutlet var remainingDaysLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var dateCell: UITableViewCell!
    @IBOutlet var remainingDaysCell: UITableViewCell!
    @IBOutlet var amountCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.item
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                
                strong.productNameLabel.text = next.product.name
                strong.productImageView.image = next.product.image
                strong.amountLabel.text = "\(next.availableAmount)"
                strong.updateBestBeforeDate(next.bestBeforeDate)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                switch strong.tableView.cellForRow(at: next) {
                    case let cell where cell == strong.amountCell:
                        strong.onAmountCellTouched?()
                    case let cell where cell == strong.remainingDaysCell || cell == strong.dateCell:
                        strong.onDateCellTouched?()
                    default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func updateBestBeforeDate(_ date: Date?) {
        defer {
            updateDateLabel(date)
            updateRemainingDaysLabel(date)
        }
        
        
        func updateDateLabel(_ date: Date?) {
            guard let date = date else {
                bestBeforeDateLabel.text = "--.--.----"
                return
            }
            
            bestBeforeDateLabel.text = DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date)
        }
        
        func updateRemainingDaysLabel(_ date: Date?) {
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy),
                NSAttributedString.Key.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
                NSAttributedString.Key.strokeWidth : 3.0,
                ] as [NSAttributedString.Key : Any]
            
            guard let date = date else {
                let text = NSMutableAttributedString(string: "--", attributes: attributes)
                text.append(NSAttributedString(string: " days left"))
                
                remainingDaysLabel.attributedText = text
                return
            }
            
            let text = NSMutableAttributedString(string: "\(Date().deltaInDays(to: date))", attributes: attributes)
            text.append(NSAttributedString(string: " days left"))
            
            remainingDaysLabel.attributedText = text
        }
    }
}
