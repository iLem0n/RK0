//
//  Scan_Controller.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class Scan_Controller: UIViewController, Scan_View {
    
    //----------------- PREPARE ------------------
    var viewModel: Scan_ViewModelType?
    let disposeBag = DisposeBag()
    
    //----------------- UI ELEMENTS ------------------
    var onCloseButtonTouched: (() -> Void)?
    var onResultsListButtonTouched: (() -> Void)?
    var onBBDButtonTouched: ((Date?) -> Void)?

    @IBOutlet var flashButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var resultListButton: UIButton!
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var clearDataButton: UIButton!
    @IBOutlet var chooseDateButton: UIButton!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var showResultProgressView: UIProgressView!

    //----------------- LIFYCYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
        
        chooseDateButton.setState(.standard)
        productLabel.setState(.standard)
    }
    
    var onCameraViewSegue: ((Scan_CameraView) -> Void)?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case let i where i == R.segue.scan_Controller.showCameraView.identifier:
            self.onCameraViewSegue?(segue.destination as! Scan_CameraView)
        default:
            fatalError("Unhandled segue: \(identifier)")
        }
    }
    
    //----------------- VIEW MODEL LINKING ------------------
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        //------ Messages --------
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
        
        //----- Button Handler -----
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onCloseButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        clearDataButton.rx.tap
            .subscribe { _ in
                viewModel.resetScanData()
            }
            .disposed(by: disposeBag)
        
        flashButton.rx.tap
            .subscribe { _ in
                viewModel.toggleFlashlight()
            }
            .disposed(by: disposeBag)
        
        resultListButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onResultsListButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        chooseDateButton.rx.tap
            .subscribe { [weak self] next in
                self?.onBBDButtonTouched?(try! viewModel.dateSubject.value() ?? nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.resultShowProgress
            .debug()
            .bind(to: showResultProgressView.rx.progress)            
            .disposed(by: disposeBag)
        
        viewModel.resultShowProgress
            .map({ $0 > 0 ? false : true })
            .bind(to: showResultProgressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        //  Item count label
        viewModel
            .scannedItems
            .map({ $0.count })
            .map({ "\($0)" })            
            .bind(to: resultCountLabel.rx.text)
            .disposed(by: disposeBag)
        
    
        //  GTIN label content
        viewModel.product
            .map({ $0?.name ?? $0?.gtin ?? "No Product" })
            .bind(to: productLabel.rx.text)
            .disposed(by: disposeBag)
        
        //  Date button content & state
        viewModel
            .dateSubject
            .map({
                guard let date = $0 else { return NSLocalizedString("Choose Date", comment: "Choose Date Button") }
                return DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date)
            })
            .bind(to: chooseDateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel
            .dateValidationState
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                strong.chooseDateButton.setState(state)
            }
            .disposed(by: disposeBag)
        
        //  switch list and clear button
        Observable
            .combineLatest(viewModel.dateValidationState, viewModel.productValidationState)
            .debug()
            .map({ $0.0 != .standard || $0.1 != .standard })
            .subscribe { [weak self] next in
                
                DispatchQueue.main.async {
                    guard let strong = self, let hasData = next.element else { return }
                    strong.resultListButton.isHidden = hasData
                    strong.clearDataButton.isHidden = !hasData
                }
            }
            .disposed(by: disposeBag)
    }
}
