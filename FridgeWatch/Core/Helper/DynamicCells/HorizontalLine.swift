//
//  HorizontalLine.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 12.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class HorizontalLine: UIView {
    convenience init() {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .lightGray
        self.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
}
