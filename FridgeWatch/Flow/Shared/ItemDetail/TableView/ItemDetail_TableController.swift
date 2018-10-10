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
    var onDateCellTouched: (() -> Void)?
    var onChangeImageButtonTouched: (() -> Void)?

    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var bestBeforeDateLabel: UILabel!
    @IBOutlet var remainingDaysLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var changeImageButton: UIButton!
    
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
        
        viewModel.productName
            .bind(to: productNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productImage
            .map({ $0 ?? #imageLiteral(resourceName: "placeholer") })
            .bind(to: productImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.productImage
            .map({ $0 == nil ? "Publish Image" : "Change Image" as String })
            .bind(to: changeImageButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.availableAmount
            .map({ "\($0)" })
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.bestBeforeDate
            .map({
                DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: $0)
            })
            .bind(to: bestBeforeDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.remainingDays
            .map({
                let text = NSMutableAttributedString(string: "\($0)", attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy),
                    NSAttributedString.Key.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
                    NSAttributedString.Key.strokeWidth : 3.0,
                    ])
                text.append(NSAttributedString(string: " days left"))
                
                log.debug(text)
                return text.string
            })
            .bind(to: remainingDaysLabel.rx.text)
            .disposed(by: disposeBag)

        changeImageButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onChangeImageButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                strong.tableView.deselectRow(at: next, animated: true)
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
