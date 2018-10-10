//
//  BadgeButton.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class BadgeButton: UIButton {
    override var layer: CALayer {
        let layer = super.layer
        layer.cornerRadius = layer.frame.size.width / 2
        layer.backgroundColor = UIColor.white.withAlphaComponent(1).cgColor
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        return layer
    }
}
