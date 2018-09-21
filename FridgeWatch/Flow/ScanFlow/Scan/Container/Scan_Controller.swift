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

    @IBOutlet var flashButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var resultListButton: UIButton!
    @IBOutlet var resultCountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gtinLabel: UILabel!

    //----------------- LIFYCYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
        
        // ensure navigation bar hidden 
        if let nav = self.navigationController {
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
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
        
        //----- Button Handler -----
        closeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onCloseButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        flashButton.rx.tap
            .subscribe { _ in
                viewModel.isFlashlightOn.toggle()                
            }
            .disposed(by: disposeBag)
        
        resultListButton.rx.tap
            .subscribe { [weak self] _ in
                self?.onResultsListButtonTouched?()
            }
            .disposed(by: disposeBag)
        
        viewModel
            .scannedItems
            .debug()
            .subscribe { [weak self] next in
                guard let strong = self, let items = next.element else { return }
                strong.resultCountLabel.text = "\(items.count)"
            }
            .disposed(by: disposeBag)
        
        viewModel
            .gtin
            .debug()
            .bind(to: gtinLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .date
            .filter({ $0 != nil }).map({ $0! })            
            .map({ DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: $0) })
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .date
            .filter({ $0 == nil })
            .map({ _ in "" })
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
