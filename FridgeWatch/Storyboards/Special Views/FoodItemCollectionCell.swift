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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var remainingDaysLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.blue.cgColor
        
        prepareAmountBadge()
    }
    
    var updateToken: NotificationToken?
    var itemID: String? {
        didSet {
            guard let itemID = itemID, let item = Realms.local.object(ofType: FoodItem.self, forPrimaryKey: itemID) else {
                resetView()
                return
            }
            
            self.updateTitleLabel(item.product.name ?? "<\(String(describing: item.product.gtin))>")
            self.updateImageView(item.product.image)
            self.updateAmount(item.availableAmount)
            self.updateBestBeforeDate(item.bestBeforeDate)
            
            updateToken = Realms.local.object(ofType: FoodItem.self, forPrimaryKey: itemID)?.observe({ [weak self] (change) in
                guard let strong = self else { return }
                switch change {
                case .change(let propertyChanges):
                    for propertyChange in propertyChanges {
                        switch propertyChange.name {
                        case "bestBeforeDate":
                            strong.updateBestBeforeDate(item.bestBeforeDate)
                        case "amount", "consumed", "thrownAway":
                            strong.updateAmount(item.availableAmount)
                        default: break
                        }
                    }
                case .deleted:
                    strong.itemID = nil
                case .error(let error):
                    log.error(error.localizedDescription)
                }
            })
        }
    }
    
    private func prepareAmountBadge() {
        amountLabel.clipsToBounds = true
        amountLabel.layer.cornerRadius = amountLabel.frame.size.width / 2
        amountLabel.backgroundColor = UIColor.white.withAlphaComponent(1)
        amountLabel.layer.borderColor = UIColor.black.cgColor
        amountLabel.layer.borderWidth = 0.25
    }
    
    private func updateTitleLabel(_ title: String?) {
        titleLabel.text = title
    }
    
    private func updateBestBeforeDate(_ date: Date?) {

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
    
    private func updateAmount(_ amount: Int?) {
        guard let amount = amount else {
            amountLabel.text = "--"
            amountLabel.isHidden = true
            return
        }
        
        if amount > 1 {
            amountLabel.text = "\(amount)"
            amountLabel.isHidden = false
        } else {
            amountLabel.isHidden = true
        }
    }
    
    private func updateImageView(_ image: UIImage?) {
        guard let image = image else {
            productImageView.image = #imageLiteral(resourceName: "placeholer")
            return
        }
        
        productImageView.image = image
    }
    
    func resetView() {
        updateTitleLabel(nil)
        updateBestBeforeDate(nil)
        updateAmount(nil)
        updateImageView(nil)
        updateToken = nil
    }
    
    override func prepareForReuse() {
        self.itemID = nil
        super.prepareForReuse()
    }
}
