//
//  PresentableType.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 07.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import UIKit

protocol PresentableType {
    func toPresent() -> UIViewController?
}

extension UIViewController: PresentableType {
    func toPresent() -> UIViewController? {
        return self
    }
}
