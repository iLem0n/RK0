//
//  ImageSearchOperation.swift
//  FridgeWatch
//
//  Created by iLem0n on 30.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit
import Moya

final class ImageSearchOperation: Operation {
    
    private let gtin: String
    public var resultImage: UIImage?
    
    //------------- INTERNAL --------------
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    //------------- LIFECYCLE --------------
    init(gtin: String) {
        self.gtin = gtin
        super.init()
    }
    
    override func start() {
        guard !self.isCancelled else {
            state = .finished
            return
        }
        
        state = .ready
        main()
    }
    
    //------------- MAIN --------------
    override func main() {
        guard !self.isCancelled else {
            state = .finished
            return
        }
        
        state = .executing
        
        
        let FETCH_LIMIT_EXCEEDED = false
        guard !FETCH_LIMIT_EXCEEDED else {
            performStubGoogleImageSearch(gtin) { (image) in
                guard !self.isCancelled else {
                    self.state = .finished
                    return
                }
                
                self.resultImage = image
                self.state = .finished
            }
            return
        }
        
        let target: ImageSearchTarget = .googleImageSearch(self.gtin)
        imageSearchBackend.request(target) { (result) in
            guard !self.isCancelled else {
                self.state = .finished
                return
            }
            
            switch result {
            case .success(let response):
                log.debug(response)
                guard let parsed: ImageResponse = target.responseParser.parse(response.data) as? ImageResponse else {
                    log.error("Response not parsed as Image Response")
                    self.state = .finished
                    return
                }
                
                let largestImage = parsed.images.sorted(by: { $0.area > $1.area }).first
                
                self.resultImage = largestImage
                self.state = .finished
                
            case .failure(let error):
                log.error(error.localizedDescription)
                self.state = .finished
            }
        }
    }
    
    private func performStubGoogleImageSearch(_ gtin: String, _ completion: @escaping (UIImage?) -> Void) {
        let target: ImageSearchTarget = .googleImageSearch("random")
        
        let url = URL(string: "https://www.googleapis.com/customsearch/v1")
        imageSearchBackend.stubRequest(target, request: URLRequest(url: url!), callbackQueue: DispatchQueue.global(qos: .background), completion: { (result) in
            guard !self.isCancelled else {
                self.state = .finished
                return
            }
            
            switch result {
            case .success(let response):
                guard let parsed: ImageResponse = target.responseParser.parse(response.data) as? ImageResponse else { return }
                let largestImage = parsed.images.sorted(by: { $0.area > $1.area }).first
                completion(largestImage)
                
            case .failure(let error):
                log.error(error.localizedDescription)
                completion(nil)
            }
        }, endpoint: imageSearchBackend.endpoint(target), stubBehavior: StubBehavior.immediate)
        return
    }
}
