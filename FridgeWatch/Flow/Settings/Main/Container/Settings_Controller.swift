//
//  Settings_Controller.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class Settings_Controller: UIViewController, Settings_View {
    
    var viewModel: Settings_ViewModelType?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    var onTableViewSegue: ((Settings_TableView) -> Void)?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case let i where i == R.segue.settings_Controller.showTableView.identifier:
            self.onTableViewSegue?(segue.destination as! Settings_TableView)
        default:
            fatalError("Unhandled segue: \(identifier)")
        }
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
        
    }
}