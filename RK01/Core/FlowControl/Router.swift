//
//  BaseRouter.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class Router: NSObject, RouterType {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func present(_ module: PresentableType?) {
        present(module, animated: true)
    }
    
    func present(_ module: PresentableType?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func dismissTopModule() {
        dismissTopModule(animated: true, completion: nil)
    }
    
    func dismissTopModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.presentedViewController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: PresentableType?)  {
        push(module, animated: true)
    }
    
    func push(_ module: PresentableType?, animated: Bool)  {
        push(module, animated: animated, hideBar: false)
    }
    
    func push(_ module: PresentableType?, animated: Bool, hideBar: Bool) {
        push(module, animated: animated, hideBar: hideBar, completion: nil)
    }
    
    func push(_ module: PresentableType?, animated: Bool, hideBar: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent() else { return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        self.rootController?.pushViewController(controller, animated: animated)
        self.rootController?.setNavigationBarHidden(hideBar, animated: animated)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: PresentableType?) {
        setRootModule(module, hideBar: false, animated: false)
    }
    
    func setRootModule(_ module: PresentableType?, animated: Bool = false) {
        setRootModule(module, hideBar: false, animated: animated)
    }
    
    func setRootModule(_ module: PresentableType?, hideBar: Bool = false) {
        setRootModule(module, hideBar: hideBar, animated: false)
    }
    
    func setRootModule(_ module: PresentableType?, hideBar: Bool = false, animated: Bool = false) {
        DispatchQueue.main.async {
            guard let controller = module?.toPresent() else { return }
            
            self.rootController?.setViewControllers([controller], animated: false)
            self.rootController?.isNavigationBarHidden = hideBar
        }
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

