//
//  ServerConnector.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation
import Starscream
import RxSwift

final class ServerConnector: NSObject  {
    static let shared = ServerConnector()
    static let MOCKUP = true
    
    private let disposeBag = DisposeBag()
    
    public lazy var isConnected: Observable<Bool> = self.isConnectedSubject.asObservable()
    private let isConnectedSubject = BehaviorSubject<Bool>(value: false)
    
    public lazy var receivedMessage: Observable<ResponseType> = self.receivedMessageSubject.asObservable()
    private let receivedMessageSubject = PublishSubject<ResponseType>()
    
    public lazy var sessionID: Observable<String?> = self.sessionIDSubject.asObservable()
    private let sessionIDSubject = BehaviorSubject<String?>(value: nil)
    
    private var socket: WebSocket?
    
    public func startSession(username: String) {
        socket = WebSocket(url: URL(string: "ws://localhost:777")!)
        socket!.delegate = self
        socket!.connect()
        
        isConnectedSubject
            .filter({ $0 == true })
            .takeLast(1)
            .subscribe({ [weak self] _ in
                guard let strong = self else { return }
                strong
                    .sendRequest(request: StartSessionRequest(name: username))
                    .subscribe({
                        guard let response = $0.element as? SessionStartResponse else { return }
                        strong.sessionIDSubject.onNext(response.sessionID)
                    })
                    .disposed(by: strong.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }
    
    public func startProcess() {
        
    }
    
    private func sendRequest<T: RequestType>(request: T) -> Observable<ResponseType> {
        guard let socket = socket else { fatalError() }
        socket.write(string: request.payload)
        return receivedMessage.take(1)
    }
}

extension ServerConnector: WebSocketDelegate {
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        isConnectedSubject.onNext(true)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        isConnectedSubject.onNext(false)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let tokens = text.split(separator: ";")
        guard let cmd = ResponseCmd(rawValue: String(tokens[0])) else { fatalError() }
        switch (cmd) {
        case .DONE: receivedMessageSubject.onNext(DoneResponse(nextStep: Int(String(tokens[2]))!))
        case .ERROR: receivedMessageSubject.onNext(ErrorResponse(message: String(tokens[1])))
        case .EXIT: receivedMessageSubject.onNext(ExitResponse(success: Bool(String(tokens[1]))!, message: String(tokens[2])))
        }
    }
}
