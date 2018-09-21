//
//  ScanResultCell.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 20.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

class ScanResultCell: SwipeTableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var item: FoodItem? {
        didSet {
            self.disposeBag = DisposeBag()
            if let item = item {
                // TODO: set view
                titleLabel.text = item.gtin
            } else {
                // TODO: reset view
                //                self.dateLabel.setState(.none)
                //                self.titleLabel?.text = nil
                //                self.dateLabel?.text = nil
                //                self.backgroundColor = .white
                //                self.productImageView.image = nil
                //                imageActivityIndicator.startAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
}
