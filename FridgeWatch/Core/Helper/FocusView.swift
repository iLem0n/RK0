//
//  FocusView.swift
//  FridgeWatch
//
//  Created by iLem0n on 21.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit


final class FocusView: UIView {
    override var layer: CALayer {
        let layer = super.layer
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.5
        layer.shadowColor = UIColor.magenta.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2

        return layer
    }
}
