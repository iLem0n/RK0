//
//  StorageContentController.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class StorageContentController: UIViewController, StorageContentView {
    
    var viewModel: StorageContentViewModelType?
    let disposeBag = DisposeBag()
    
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
                        view.configureContent(title: next.title, body: next.text)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
