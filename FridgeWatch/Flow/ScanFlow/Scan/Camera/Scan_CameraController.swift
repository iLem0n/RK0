//
//  Scan_CameraController.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 15.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import RxGesture

final class Scan_CameraController: UIViewController, Scan_CameraView {
    //----------------- PREPARE ------------------
    var viewModel: Scan_ViewModelType?
    let disposeBag = DisposeBag()
    
    //----------------- LIFECYCLE ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.scannerStateSubject.onNext(.tearUp)
        
        if !self.navigationController!.isNavigationBarHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            previewLayer?.frame.size = UIScreen.main.bounds.size
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.scannerStateSubject.onNext(.tearDown)
    }
    
    //----------------- VIEW MODEL LINKING ------------------
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        viewModel.scannerStateSubject
            .distinctUntilChanged({ $0 == $1 })
            .subscribe { [weak self] next in
                guard let strong = self, let state = next.element else { return }
                switch state {
                case .tearUp:
                    strong.startCapture()
                case .tearDown:
                    strong.stopCapture()
                case .ready:
                    break
                case .pause:
                    break
                case .error(let scannerError):
                    viewModel.message.onNext(Message(type: .error, title: "Scanner Error", message: scannerError.localizedDescription))
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.flashlightStateObservable
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                switch next {
                case .dimmed(let dimmValue):
                    strong.turnFlashlightOn(true, dimmValue: dimmValue)
                case .on:
                    strong.turnFlashlightOn(true, dimmValue: 1.0)
                case .off:
                    strong.turnFlashlightOn(false)
                }
            }
            .disposed(by: disposeBag)
        
        self.view.rx
            .anyGesture(.tap())
            .when(.ended)
            .subscribe { [weak self] in
                guard let strong = self, let next = $0.element else { return }
                
                let touchPoint = next.location(in: strong.view)
                strong.view.makePop(at: touchPoint)

                guard let devicePoint = strong.previewLayer?.captureDevicePointConverted(fromLayerPoint: touchPoint),
                    strong.captureDevice != nil
                else { return }
                
                strong.focusOn(devicePoint)
            }
            .disposed(by: disposeBag)
    }
    
    //----------------- CAMERA ------------------
    @IBOutlet var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice?

    private func startCapture() {
        guard let viewModel = viewModel else { return }
        
        //  prepare device and session
        captureSession = AVCaptureSession()
        captureDevice = AVCaptureDevice.default(for: .video)
        guard let captureDevice = captureDevice else { return }
        
        guard
            let captureSession = captureSession,
            let input = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            viewModel.scannerStateSubject.onNext(.error(.notSupportedByDevice))
            viewModel.message.onNext(Message(type: .error, title: "Camera Error", message: "Unable to initialize camera session."))
            return
        }
        
        // prepare output
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
        output.setSampleBufferDelegate(viewModel, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background))
        
        // start session
        captureSession.sessionPreset = .high
        captureSession.addInput(input)
        captureSession.addOutput(output)
        makePreviewLayer(session: captureSession)
        
        captureSession.startRunning()
    }
    
    private func turnFlashlightOn(_ on: Bool, dimmValue: Float = 1.0) {
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.torchMode = on ? .on : .off
            if on {
                try captureDevice?.setTorchModeOn(level: dimmValue)
            }
            captureDevice?.unlockForConfiguration()
        } catch {
            log.error("Unable to lock camera device. (torchLevel)")
        }
    }
    
    private func focusOn(_ point: CGPoint) {
        do {
            try captureDevice?.lockForConfiguration()
            
            captureDevice?.focusPointOfInterest = point
            captureDevice?.focusMode = .autoFocus
            
            captureDevice?.exposurePointOfInterest = point
            captureDevice?.exposureMode = .continuousAutoExposure
            
            captureDevice?.unlockForConfiguration()
            
        } catch {
            log.error("Unable to lock camera device. (focusPoint)")
        }
    }
    
    private func makePreviewLayer(session: AVCaptureSession) {
        previewLayer?.removeFromSuperlayer()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer?.frame.size = self.view.frame.size
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.videoOrientation = currentOrientation
                
        self.view.layer.addSublayer(previewLayer!)
    }
    
    private func stopCapture() {
        captureSession?.stopRunning()
        captureSession = nil
        previewLayer?.removeFromSuperlayer()
    }
    
    private var currentOrientation: AVCaptureVideoOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .unknown: return .portrait
        }
    }
}

