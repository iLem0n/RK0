//
//  KeyboardManager.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 29.11.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import UIKit
import RxSwift

public enum KeyboardState {
    case hidden(KeyboardTransition)
    case shown(KeyboardTransition)
}

public struct KeyboardTransition {
    var animationDuration: Double?
    var endFrame: CGRect = CGRect.zero
    
    var isAnimating: Bool {
        guard let duration = animationDuration else { return false }
        return duration > 0.0
    }
}

public final class KeyboardManager: NSObject {
    static let shared: KeyboardManager = KeyboardManager()
    
    public lazy var state: Observable<KeyboardState?> = self.stateSubject.asObservable()
    private let stateSubject = BehaviorSubject<KeyboardState?>(value: nil)
    
    public override init() {
        
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func transition(from notification: NSNotification) -> KeyboardTransition? {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return nil }
        
        let endFrame = endFrameValue.cgRectValue
        
        let transition = KeyboardTransition(animationDuration: animationDuration, endFrame: endFrame)
        return transition
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let transition = self.transition(from: notification) else { fatalError() }
        stateSubject.onNext(.shown(transition))
    }
    
    @objc private func keyboardDidShow(_ notification: NSNotification) {
        guard let transition = self.transition(from: notification) else { fatalError() }
        stateSubject.onNext(.shown(transition))
    }
    
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let transition = self.transition(from: notification) else { fatalError() }
        stateSubject.onNext(.hidden(transition))
    }

    @objc private func keyboardDidHide(_ notification: NSNotification) {
        guard let transition = self.transition(from: notification) else { fatalError() }
        stateSubject.onNext(.hidden(transition))
    }
}
