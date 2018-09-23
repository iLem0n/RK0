//
//  RouterType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol RouterType: PresentableType {
    func present(_ module: PresentableType?)
    func present(_ module: PresentableType?, animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func dismissTopModule()
    func dismissTopModule(animated: Bool, completion: (() -> Void)?)
    
    
    
    func push(_ module: PresentableType?)
    func push(_ module: PresentableType?, animated: Bool, hideBar: Bool)    
    func push(_ module: PresentableType?, animated: Bool, hideBar: Bool, completion: (() -> Void)?)

    func popModule()
    func popModule(animated: Bool)
    
    func setRootModule(_ module: PresentableType?)
    func setRootModule(_ module: PresentableType?, hideBar: Bool)
    func setRootModule(_ module: PresentableType?, hideBar: Bool, animated: Bool)
    
    func popToRootModule(animated: Bool)
}
