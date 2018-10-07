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
    
    //----------------- PREPARE ------------------
    var viewModel: ScanResults_ViewModelType?
    let disposeBag = DisposeBag()
    
    //----------------- COORDINATOR LINKS ------------------
    var onSaved: (() -> Void)?
    
    //----------------- LIFYCYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        linkViewModel()
    }
    
    var onTableViewSegue: ((ScanResults_TableView) -> Void)?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case let i where i == R.segue.scanResults_Controller.showTableView.identifier:
            self.onTableViewSegue?(segue.destination as! ScanResults_TableView)
        default:
            fatalError("Unhandled segue: \(identifier)")
        }
    }
    
    //----------------- VIEW MODEL LINKING ------------------
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
        
        self.navigationItem.rightBarButtonItem!.rx.tap
            .subscribe { [weak self] _ in
                viewModel.saveScanResults { success in
                    guard success else { return }
                    self?.onSaved?()
                }
            }
            .disposed(by: disposeBag)
    }
}
