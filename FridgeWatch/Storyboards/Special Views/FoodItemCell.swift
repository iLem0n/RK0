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
    @IBOutlet var dateLabel: UILabel!

    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var item: FoodItem? {
        didSet {
            self.disposeBag = DisposeBag()
            if let item = item {
                log.debug(Thread.isMainThread)
                titleLabel.text = item.product.name ?? "<\(String(describing: item.product.gtin))>"                
                dateLabel.text = DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: item.bestBeforeDate)
            } else {
                //  reset view
                self.titleLabel.text = nil
                self.dateLabel.text = nil
                self.disposeBag = DisposeBag()
            }
        }
    }
}
