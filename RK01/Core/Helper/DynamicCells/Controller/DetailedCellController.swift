//
//  DetailedCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class DetailedCellController: SwipeTableViewCell, DynamicCellType {    
    typealias SettingType = DetailedCellSetting
    private let disposeBag = DisposeBag()

    func configure(with setting: SettingType) {
        if let title = setting.title {
            self.textLabel?.text = title
        } else if let dynamicTitle = setting.dynamicTitle, let textLabel = self.textLabel {
            dynamicTitle
                .bind(to: textLabel.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let subtitle = setting.subtitle {
            self.detailTextLabel?.text = subtitle
        } else if let dynamicSubtitle = setting.dynamicSubtitle, let detailTextLabel = self.detailTextLabel {
            dynamicSubtitle
                .bind(to: detailTextLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }
}
