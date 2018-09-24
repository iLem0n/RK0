//
//  StorageContent_Controller.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class StorageContent_Controller: UIViewController, StorageContent_View {

    //-------------------- PREPARATION -------------------------
    var viewModel: StorageContent_ViewModelType?
    let disposeBag = DisposeBag()
    
    //-------------------- COORDINATOR LINKS -------------------------
    var onCollectionViewSegue: ((StorageContent_CollectionView) -> Void)?
    var onStartScanButtonTouched: (() -> Void)?
    
    //-------------------- UI ELEMENTS -------------------------
    @IBOutlet var startScanButton: UIButton!
    
    //-------------------- INITIALISATION -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case let i where i == R.segue.storageContent_Controller.showCollectionView.identifier:
            self.onCollectionViewSegue?(segue.destination as! StorageContent_CollectionView)
        default:
            fatalError("Unhandled segue: \(identifier)")
        }
    }
    
    //-------------------- VIEW MODEL LINKING -------------------------
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
        
        startScanButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onStartScanButtonTouched?()
            }
            .disposed(by: disposeBag)
    }
}
