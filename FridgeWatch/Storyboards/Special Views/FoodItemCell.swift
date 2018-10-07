//
//  FoodItemCell.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.


import UIKit
import SwipeCellKit
import RxSwift

class FoodItemCell: SwipeTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var remainingDaysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareAmountBadge()
    }
    
    var item: FoodItem? {
        didSet {
            guard let item = item else {
                resetView()
                return
            }
       
            self.updateTitleLabel(item.product.name ?? "<\(String(describing: item.product.gtin))>")
            self.updateBestBeforeDate(item.bestBeforeDate)
            self.updateAmount(item.availableAmount)
            self.updateImageView(item.product.image)
        }
    }
    
    private func updateTitleLabel(_ title: String?) {
        titleLabel.text = title
    }
    
    private func updateBestBeforeDate(_ date: Date?) {
        defer {
            updateDateLabel(date)
            updateRemainingDaysLabel(date)
        }
        
        
        func updateDateLabel(_ date: Date?) {
            guard let date = date else {
                dateLabel.text = "--.--.----"
                return
            }
            
            dateLabel.text = DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date)
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
    
    private func prepareAmountBadge() {
        amountLabel.clipsToBounds = true
        amountLabel.layer.cornerRadius = amountLabel.frame.size.width / 2
        amountLabel.backgroundColor = UIColor.white.withAlphaComponent(1)
        amountLabel.layer.borderColor = UIColor.black.cgColor
        amountLabel.layer.borderWidth = 0.25
    }
    
    func resetView() {
        updateTitleLabel(nil)
        updateBestBeforeDate(nil)
        updateAmount(nil)
        updateImageView(nil)
    }
    
    override func prepareForReuse() {
        self.item = nil
        super.prepareForReuse()
    }
}
