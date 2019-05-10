//
//  LoginView.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol LoginView: BaseViewType {
    var viewModel: LoginViewModelType? { get set }
    
    var onLoginButtonClicked: ((String) -> Void)? { get set }
}
