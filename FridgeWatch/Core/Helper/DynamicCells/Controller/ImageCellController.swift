//
//  ImageCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 06.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit
import RxSwift

final class ImageCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = ImageCellSetting
    private let disposeBag = DisposeBag()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var cellImageView: UIImageView!
    
    func configure(with setting: SettingType) {
        if let title = setting.title {
            self.titleLabel.text = title
        } else if let dynamicTitle = setting.dynamicTitle {
            dynamicTitle
                .bind(to: titleLabel.rx.text)
                .disposed(by: disposeBag)
        }
      
        if let subtitle = setting.subtitle {
            self.subtitleLabel.text = subtitle
        } else if let dynamicSubtitle = setting.dynamicSubtitle {
            dynamicSubtitle
                .bind(to: subtitleLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let image = setting.image {
            self.cellImageView.image = image
        } else if let dynamicImage = setting.dynamicImage {
            dynamicImage
                .bind(to: cellImageView.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
