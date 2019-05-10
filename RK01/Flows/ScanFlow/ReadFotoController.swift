//
//  ReadFotoController.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages
import MicroBlink

class ReadFotoController: UIViewController, ReadFotoView, MBBarcodeOverlayViewControllerDelegate  {
    
    var viewModel: ReadFotoViewModelType?
    let disposeBag = DisposeBag()
    var rawParser: MBRawParser?
    var parserGroupProcessor: MBParserGroupProcessor?
    var blinkInputRecognizer: MBBlinkInputRecognizer?
    
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
                        view.configureContent(title: next.title, body: next.message)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func didTapScan(_ sender: AnyObject) {
        
        let settings = MBBarcodeOverlaySettings()
        rawParser = MBRawParser()
        parserGroupProcessor = MBParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBBlinkInputRecognizer(processors: [parserGroupProcessor!])
        
        let recognizerList = [self.blinkInputRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let barcodeOverlayViewController : MBBarcodeOverlayViewController = MBBarcodeOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunnerViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: barcodeOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController, animated: true, completion: nil)
    }
    
    func barcodeOverlayViewControllerDidFinishScanning(_ barcodeOverlayViewController: MBBarcodeOverlayViewController, state: MBRecognizerResultState) {
        
        // this is done on background thread
        // check for valid state
        if state == MBRecognizerResultState.valid {
            
            // first, pause scanning until we process all the results
            barcodeOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            DispatchQueue.main.async(execute: {() -> Void in
                // All UI interaction needs to be done on main thread
            })
        }
    }
    
    func barcodeOverlayViewControllerDidTapClose(_ barcodeOverlayViewController: MBBarcodeOverlayViewController) {
        // Your action on cancel
    }
}



