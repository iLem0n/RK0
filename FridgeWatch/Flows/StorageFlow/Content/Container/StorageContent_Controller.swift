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
    var onSettingsButtonTouched: (() -> Void)?

    //-------------------- UI ELEMENTS -------------------------
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var startScanButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var bulkConsumeButton: UIButton!
    @IBOutlet var bulkThrowAwayButton: UIButton!
    @IBOutlet var commitBulkEditingButton: UIButton!
    @IBOutlet var discardBulkEditingButton: UIButton!

    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var bottomLeftButtonsConstraint: NSLayoutConstraint!
    @IBOutlet var bottomRightButtonsConstraint: NSLayoutConstraint!
        
    //-------------------- INITIALISATION -------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.navigationController!.isNavigationBarHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        super.viewDidAppear(animated)        
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
                        view.configureContent(title: next.title, body: next.message)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
        
        //  KEYBOARD MOVEMENT
        KeyboardManager.shared.state
            .subscribe {
                guard let element = $0.element, let state = element else { return }
                switch state {
                case .hidden(_):
                    self.bottomConstraint.constant = 0
                    self.bottomLeftButtonsConstraint.constant = 0
                    self.bottomRightButtonsConstraint.constant = 0
                case .shown(let transition):
                    let offset = transition.endFrame.size.height - (self.tabBarController?.tabBar.frame.height ?? 0)
                    self.bottomConstraint.constant = offset
                    self.bottomLeftButtonsConstraint.constant = offset + 15
                    self.bottomRightButtonsConstraint.constant = offset + 15
                }
            }
            .disposed(by: disposeBag)
        
        startScanButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onStartScanButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onSettingsButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        bulkConsumeButton.rx.tap
            .subscribe { _ in
                viewModel.bulkEditingMode.onNext(.consume)
            }
            .disposed(by: disposeBag)
        
        bulkThrowAwayButton.rx.tap
            .subscribe { _ in
                viewModel.bulkEditingMode.onNext(.throwAway)
            }
            .disposed(by: disposeBag)
        
        commitBulkEditingButton.rx.tap
            .subscribe { _ in
                viewModel.commitBulkChange()
            }
            .disposed(by: disposeBag)
        
        discardBulkEditingButton.rx.tap
            .subscribe { _ in
                viewModel.discardBulkChange()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .filter({ $0 != nil }).map({ $0! })
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .subscribe { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        viewModel.bulkEditingMode
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                
                DispatchQueue.main.async {
                    strong.bulkConsumeButton.isHidden = next != .none && next != .consume
                    strong.bulkConsumeButton.isEnabled = next == .none
                    
                    strong.bulkThrowAwayButton.isHidden = next != .none && next != .throwAway
                    strong.bulkThrowAwayButton.isEnabled = next == .none
                    
                    strong.startScanButton.isHidden = next != .none
                    
                    strong.discardBulkEditingButton.isHidden = next == .none
                    strong.commitBulkEditingButton.isHidden = next == .none
                }
            }
            .disposed(by: disposeBag)
    }
}

