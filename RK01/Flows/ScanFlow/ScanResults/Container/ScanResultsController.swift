//
//  ScanResults_Controller.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class ScanResults_Controller: UIViewController, ScanResults_View {
    
    var viewModel: ScanResults_ViewModelType?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    var onTableViewSegue: ((ScanResultsTableView) -> Void)?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case let i where i == R.segue.<#ParentController#>.showTableView.identifier:
            self.onTableViewSegue?(segue.destination as! ScanResultsTableView)
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
                        view.configureContent(title: next.title, body: next.text)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
}
