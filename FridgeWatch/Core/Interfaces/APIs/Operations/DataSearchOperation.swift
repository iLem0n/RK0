//
//  DataSearchOperation.swift
//  FridgeWatch
//
//  Created by iLem0n on 30.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

final class DataSearchOperation: Operation {
    
    private let gtin: String
    public var resultName: String?
    
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
        
        var responseCnt = 0
        let targets: [DataSearchTarget] = [.gtinsuche(gtin), .codecheck(gtin)]
        var collectedNames: [String] = []
        
        for target in targets {
            dataSearchProvider.request(target) { (result) in
                guard !self.isCancelled else {
                    self.state = .finished
                    return
                }
                
                switch result {
                case .success(let response):
                    if let productData: ProductDataResponse = target.responseParser.parse(response.data) as? ProductDataResponse {
                        collectedNames.append(contentsOf: productData.names)
                    }
                    responseCnt += 1
                case .failure(let error):
                    log.error(error.localizedDescription)
                    responseCnt += 1
                }
                
                
                if responseCnt == targets.count {
                    self.resultName = collectedNames.first
                    self.state = .finished
                }
            }
        }
    }
}
