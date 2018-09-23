//
//  UITextField+ValidationState.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 09.03.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import UIKit

protocol StateableView {
    func setState(_ state: ViewState)
}

enum ViewState {
    case none, standard, success, warning, info, error
    
    var primaryColor: UIColor {
        switch self {
        case .none:         return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        case .standard:     return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        case .info:         return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case .success:      return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .warning:      return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .error:        return #colorLiteral(red: 0.9090260863, green: 0.1296007037, blue: 0, alpha: 1)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .none:         return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        default:            return self.primaryColor.withAlphaComponent(0.5)
        }
        
    }
}

extension StateableView where Self: UIView {
    func setState(_ state: ViewState) {
        layer.cornerRadius = self.frame.size.height / 3
        
        self.backgroundColor = state.secondaryColor
        layer.shadowColor = state.primaryColor.cgColor
        layer.borderColor = state.primaryColor.cgColor
        
    }
}

extension UIButton: StateableView {
    func setState(_ state: ViewState) {
        layer.cornerRadius = 5.0
        
        self.backgroundColor = state.secondaryColor
        layer.shadowColor = state.primaryColor.cgColor
        layer.borderColor = state.primaryColor.cgColor

        self.setTitleColor(.lightGray, for: .disabled)
        self.setTitleColor(.darkGray, for: .highlighted)
        self.setTitleColor(.white, for: .normal)
    }
}
extension UILabel: StateableView {}
extension UITextField: StateableView {}
extension UITableViewCell: StateableView {
    func setState(_ state: ViewState) {        
        self.backgroundColor = state.secondaryColor
        layer.shadowColor = state.primaryColor.cgColor
        layer.borderColor = state.primaryColor.cgColor
    }
}
