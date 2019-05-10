//
//  LoginViewModel.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift

final class LoginViewModel: NSObject, LoginViewModelType {
    let message = PublishSubject<Message>()
    
    let username = BehaviorSubject<String?>(value: nil)
    let password = BehaviorSubject<String?>(value: nil)
    
    
}
