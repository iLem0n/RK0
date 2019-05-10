//
//  LoginController.swift
//
//  RK01
//
//  Created by iLem0n on 09.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class LoginController: UIViewController, LoginView {
    
    var viewModel: LoginViewModelType?
    let disposeBag = DisposeBag()
    
    var onLoginButtonClicked: ((String) -> Void)?
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        //  Messages
        viewModel.message
            .subscribe{
                guard let next = $0.element else { return }
                DispatchQueue.main.async {
                    SwiftMessages.show {
                        let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
                        view.configureTheme(next.type)
                        view.configureContent(title: next.title, body: next.message)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        viewModel.username
            .map({ $0 != nil && $0!.count > 0 })
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                loginButton.rx.controlEvent(.touchUpInside),
                viewModel.username
            )
            .subscribe({ [weak self] in
                guard let strong = self, let element = $0.element, let username = element.1 else { return }
                strong.onLoginButtonClicked?(username)
            })
            .disposed(by: disposeBag)
    }
}
