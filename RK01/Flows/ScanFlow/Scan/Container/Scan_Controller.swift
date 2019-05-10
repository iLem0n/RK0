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

final class Scan_Controller: UIViewController, ScanView {
    
    //----------------- PREPARE --------------------
    var viewModel: ScanViewModelType?
    let disposeBag = DisposeBag()
    
    //------------- COORDINATOR HOOKS ---------------
    var onSendButtonClicked: ((String) -> Void)?

    //----------------- UI ELEMENTS ------------------
    @IBOutlet var flashButton: UIButton!
    @IBOutlet var manualInputTextField: UITextField!
    @IBOutlet var sendButton: UIButton!

    //----------------- LIFYCYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkButtonHandler()
        linkViewModel()
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
        
        //  - Flashlight
        flashButton.rx.tap
            .subscribe { _ in
                viewModel.toggleFlashlight()
            }
            .disposed(by: disposeBag)
        
        //  - disable send button when no or invalid data
        viewModel.textSubject
            .map({ $0 != nil && $0!.count > 0})        
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)

        //  set button text to match the data which will be send
        viewModel.textSubject
            .map({ $0 != nil ? "Send \"\($0!)\"" : "Fill in or Scan" })            
            .bind(to: sendButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        manualInputTextField.rx.text
            .bind(to: viewModel.textSubject)
            .disposed(by: disposeBag)
        
        //  - Button
        Observable
            .combineLatest(
                sendButton.rx.controlEvent(.touchUpInside),
                viewModel.textSubject.asObserver()
            )
            .subscribe({ [weak self] in
                guard let strong = self, let element = $0.element, let text = element.1 else { return }
                strong.onSendButtonClicked?(text)
            })
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
    }
}



