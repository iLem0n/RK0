//
//  DefaultCellController.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 30.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift

final class DefaultCellController: SwipeTableViewCell, DynamicCellType {
    typealias SettingType = DefaultCellSetting
    
    private let disposeBag = DisposeBag()
    
    func configure(with setting: SettingType) {
        if let title = setting.title {
            self.textLabel?.text = title
        } else if let dynamicTitle = setting.dynamicTitle, let textLabel = self.textLabel {
            dynamicTitle
                .bind(to: textLabel.rx.text)
                .disposed(by: disposeBag)
        }
    }
}
