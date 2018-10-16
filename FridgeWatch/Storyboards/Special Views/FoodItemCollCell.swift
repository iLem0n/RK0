//
//  FoodItemCollectionCell.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import SwipeCellKit
import RxSwift
import RealmSwift

class FoodItemCollectionCell: SwipeCollectionViewCell {
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var remainingDaysLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var amountLabel: UILabel!
    
    @IBOutlet var editingView: UIView!
    @IBOutlet var amountEditingLabel: UILabel!
    @IBOutlet var totalAmountEditingLabel: UILabel!
    @IBOutlet var amountStepper: UIStepper!
    @IBOutlet var editAllButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.blue.cgColor
        
        editAllButton.layer.cornerRadius = 5
        editAllButton.layer.borderWidth = 0.25
        editAllButton.layer.borderColor = UIColor.blue.cgColor
        
        editingView.layer.cornerRadius = 10
        editingView.layer.borderWidth = 1.5
        editingView.layer.borderColor = UIColor.blue.cgColor
        
        prepareAmountBadge()
    }
    
    var updateToken: NotificationToken?
    var viewModel: FoodItemColl_CellViewModelType? {
        didSet {
            linkViewModel()
        }
    }    
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { return }
        
        //  Title
        viewModel.productName
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        //  Product image
        viewModel.productImage
            .bind(to: productImageView.rx.image)
            .disposed(by: disposeBag)
        
        //  Amount
        viewModel.amount
            .map({ Double($0) })
            .subscribe { [weak self] in
                guard let strong = self,  let next = $0.element else { return }
                strong.amountStepper.maximumValue = next
            }
            .disposed(by: disposeBag)
        
        viewModel.amount
            .map({ "\($0) "})
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.amount
            .map({ "\($0) "})
            .bind(to: totalAmountEditingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.editedAmount
            .map({ "\($0)" })
            .bind(to: amountEditingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.editedAmount
            .map({ Double($0) })
            .bind(to: amountStepper.rx.value)
            .disposed(by: disposeBag)
        
        amountStepper.rx.value
            .map({ Int($0) })
            .filter({ $0 != nil }).map({ $0! })
            .bind(to: viewModel.editedAmount)
            .disposed(by: disposeBag)

        editAllButton.rx.tap
            .subscribe { _ in
                viewModel.selectAllToEdit()
            }
            .disposed(by: disposeBag)

        //  Date
        viewModel.bestBeforeDate
            .map({
                let attributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy),
                    NSAttributedString.Key.textEffect : NSAttributedString.TextEffectStyle.letterpressStyle,
                    NSAttributedString.Key.strokeWidth : 3.0,
                    ] as [NSAttributedString.Key : Any]
                
                let text = NSMutableAttributedString(string: "\(Date().deltaInDays(to: $0))", attributes: attributes)
                text.append(NSAttributedString(string: " days left"))
                
                return text
            })
            .bind(to: remainingDaysLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        //  Editing Mode 
        viewModel.editingModeObservable
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                
                switch next {
                case .none:
                    strong.editingView.isHidden = true
                case .consume:
                    strong.editingView.isHidden = false
                case .throwAway:
                    strong.editingView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
//        viewModel?.itemSubject
//            .subscribe { [weak self] in
//                guard let strong = self, let next = $0.element else { return }
//
//                strong.updateTitleLabel(next.product.name ?? "<\(String(describing: next.product.gtin))>")
//                strong.updateImageView(next.product.image)
//                strong.updateAmount(next.availableAmount)
//                strong.updateBestBeforeDate(next.bestBeforeDate)
//
//                strong.updateToken = next.observe({ (change) in
//                    switch change {
//                    case .change(let propertyChanges):
//                        for propertyChange in propertyChanges {
//                            switch propertyChange.name {
//                            case "bestBeforeDate":
//                                strong.updateBestBeforeDate(next.bestBeforeDate)
//                            case "amount", "consumed", "thrownAway":
//                                strong.updateAmount(next.availableAmount)
//                            default: break
//                            }
//                        }
//                    case .deleted: break
//                    case .error(let error):
//                        log.error(error.localizedDescription)
//                    }
//                })
//            }
//            .disposed(by: disposeBag)
        
    

    }
    
    private func prepareAmountBadge() {
        amountLabel.clipsToBounds = true
        amountLabel.layer.cornerRadius = amountLabel.frame.size.width / 2
        amountLabel.backgroundColor = UIColor.white.withAlphaComponent(1)
        amountLabel.layer.borderColor = UIColor.black.cgColor
        amountLabel.layer.borderWidth = 0.25
    }
//
//    private func updateTitleLabel(_ title: String?) {
//        titleLabel.text = title
//    }
//
//    private func updateBestBeforeDate(_ date: Date?) {
//
//
//
//    }
//
//    private func updateAmount(_ amount: Int?) {
//        guard let amount = amount else {
//            amountLabel.text = "--"
//            amountEditingLabel.text = "--"
//            amountLabel.isHidden = true
//            return
//        }
//
//        if amount > 1 {
//            amountLabel.text = "\(amount)"
//            amountEditingLabel.text = "\(amount)"
//            amountLabel.isHidden = false
//        } else {
//            amountLabel.isHidden = true
//        }
//    }
//
//    private func updateImageView(_ image: UIImage?) {
//        guard let image = image else {
//            productImageView.image = #imageLiteral(resourceName: "placeholer")
//            return
//        }
//
//        productImageView.image = image
//    }
    
    func resetView() {
        titleLabel.text = nil
        remainingDaysLabel.text = nil
        amountEditingLabel.text = nil
        amountLabel.text = nil
        productImageView.image = nil
        updateToken = nil
        disposeBag = DisposeBag()
        
    }
    
    override func prepareForReuse() {
        self.resetView()
        super.prepareForReuse()
    }
}
