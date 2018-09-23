//
//  SyncButton.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 22.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class SyncButton: UIButton {
    private var onAction: (() -> Void)?
    convenience init(title: String? = nil, initialState: ViewState = .standard, action: @escaping () -> Void) {
        self.init(title: title, initialState: initialState)
        self.onAction = action
        self.addTarget(self, action: #selector(SyncButton.onTouchUpInside), for: .touchUpInside)
    }
    
    @objc private func onTouchUpInside() {
        self.onAction?()
    }
}
