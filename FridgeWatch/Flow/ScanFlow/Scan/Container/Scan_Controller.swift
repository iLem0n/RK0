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
import RxGesture

final class Scan_Controller: UIViewController, Scan_View {
    
    //----------------- PREPARE --------------------
    var viewModel: Scan_ViewModelType?
    let disposeBag = DisposeBag()
    
    //------------- COORDINATOR HOOKS ---------------
    var onCloseButtonTouched: (() -> Void)?
    var onResultsListButtonTouched: (() -> Void)?
    var onBBDButtonTouched: ((Date?) -> Void)?

    //----------------- UI ELEMENTS ------------------
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var resultListButton: UIButton!
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var clearDataButton: UIButton!
    @IBOutlet var chooseDateButton: UIButton!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var addToListButton: UIButton!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var amountSlider: VSSlider!

    //----------------- LIFYCYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkButtonHandler()
        linkViewModel()
        
        chooseDateButton.setState(.standard)
        productLabel.setState(.standard)
        
        amountLabel.layer.cornerRadius = amountLabel.frame.height / 3
        resultCountLabel.layer.cornerRadius = resultCountLabel.frame.height / 3
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
    private func linkButtonHandler() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        //  - Close
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onCloseButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        //  - Clear Data
        clearDataButton.rx.tap
            .subscribe { _ in
                viewModel.resetScanData()
            }
            .disposed(by: disposeBag)
        
        //  - Flashlight
        flashButton.rx.tap
            .subscribe { _ in
                viewModel.toggleFlashlight()
            }
            .disposed(by: disposeBag)
        
        //  - Show Scan results
        resultListButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onResultsListButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        //  - Manual Date Selection
        chooseDateButton.rx.tap
            .subscribe { [weak self] next in
                guard let dateValue = try? viewModel.dateSubject.value() else { return }
                self?.onBBDButtonTouched?(dateValue ?? nil)
            }
            .disposed(by: disposeBag)
        
        //  - Add Scanned item to list
        addToListButton.rx.tap
            .subscribe { _ in
                viewModel.addItemToList()
            }
            .disposed(by: disposeBag)
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
     
        
        //  Messages
        viewModel.message
            .debug()
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

        //  Amount Slider ~> amount ~> Amount Label
        amountSlider.rx.value
            .map({ Int($0) })
            .bind(to: viewModel.amountSubject)
            .disposed(by: disposeBag)

        viewModel.amountSubject
            .map({ "\($0)" })
            .bind(to: amountLabel.rx.text)
            .disposed(by: disposeBag)

        //  Date Button | Text & State
        viewModel.dateSubject
            .map({
                guard let date = $0 else { return NSLocalizedString("Choose Date", comment: "Choose Date Button") }
                return DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date)
            })
            .bind(to: chooseDateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        viewModel.dateValidationStateObservable
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                self?.chooseDateButton.setState(next)
            }
            .disposed(by: disposeBag)
        
        //  Product Label | Text & State
        viewModel.productObservable
            .map({ $0?.name ?? $0?.gtin ?? "No Product" })
            .map({ String(describing: $0) })
            .bind(to: productLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.productValidationStateObservable
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                self?.productLabel.setState(next)
            }
            .disposed(by: disposeBag)

        //  Show clear-/addToListButton deopendinfg on data state
        viewModel.scanDataState
            .subscribe { [weak self] in
                guard let next = $0.element else { return }
                DispatchQueue.main.async {
                    self?.resultListButton.isHidden = next != .none
                    self?.clearDataButton.isHidden = next == .none
                    self?.addToListButton.isHidden = next != .all
                }
            }
            .disposed(by: disposeBag)
        
        
        //  Item count label
        viewModel
            .scannedItemsSubject
            .map({ $0.count })
            .map({ "\($0)" })
            .bind(to: resultCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
}



