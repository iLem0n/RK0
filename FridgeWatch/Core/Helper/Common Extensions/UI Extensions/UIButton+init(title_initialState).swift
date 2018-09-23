//
//  UIButton+init(title_initialState).swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 22.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String? = nil, initialState: ViewState = .standard) {
        self.init(type: .custom)
        self.setState(initialState)
        self.setTitle(title, for: .normal)
    }
}
