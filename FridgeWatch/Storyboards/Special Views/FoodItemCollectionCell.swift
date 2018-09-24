//
//  FoodItemCollectionCell.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import SwipeCellKit
import RxSwift

class FoodItemCollectionCell: SwipeCollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var item: FoodItem? {
        didSet {
            self.disposeBag = DisposeBag()
            if let item = item {
                titleLabel.text = item.product.name ?? "<\(String(describing: item.product.gtin))>"
                if let image = item.product.image {
                    imageView.image = image
                }
                dateLabel.text = DateFormatter(timeStyle: .none, dateStyle: .short).string(from: item.bestBeforeDate)
            } else {
                //  reset view
                self.titleLabel.text = nil
                self.dateLabel.text = nil
                self.disposeBag = DisposeBag()
            }
        }
    }
}
