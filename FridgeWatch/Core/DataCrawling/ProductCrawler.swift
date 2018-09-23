//
//  ProductCrawler.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 22.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Result
import Moya
import Freddy

final class ProductCrawler: NSObject, FoodCrawlerType {
    static var shared: FoodCrawlerType = ProductCrawler()
    
    func getProductData(_ gtin: String, _ resultHandler: (Result<Product, FoodCrawlerError>) -> Void) {
        log.debug(#function)
        if let matchingProdcut = Realms.local.object(ofType: Product.self, forPrimaryKey: gtin) {
            resultHandler(.success(matchingProdcut))
        } else {
            resultHandler(.failure(.unknownProduct))
            self.updateProductData(gtin)
        }
    }
    
    func updateProductData(_ gtin: String) {
        if let product = Realms.local.object(ofType: Product.self, forPrimaryKey: gtin) {
            collectAPIResponses(gtin: gtin) { [weak self] (responses) in
                guard let strong = self else { return }
                
                var namesFound = responses.flatMap({ $0.names })
                if let existingName = product.name {
                    namesFound.append(existingName)
                }
                
                let realm = Realms.local
                try! realm.write {
                    if let name = strong.suggestName(namesFound) {
                        product.name = name
                    }
                }
            }
        } else {
            FoodFactory.makeProduct(gtin) { (result) in
                switch result {
                case .success(_):
                    updateProductData(gtin)
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            }
        }
    }
    
    func suggestName(_ nameValues: [String]) -> String? {
        log.debug(nameValues)
        guard nameValues.count > 0 else { return nil }
        guard nameValues.count > 1 else { return nameValues.first! }
        
        //  TODO: Do real comparision and suggestion
        return nameValues.first
    }
    
    //------------------ APIs ---------------------
    private var apis: [API] = [.google, .datakick, .gtinsuche]
    private func collectAPIResponses(gtin: String, _ completion: @escaping ([ProductDataResponseType]) -> Void) {
        var results: [ProductDataResponseType] = []
        var apiCnt = apis.count
        
        for api in apis {
            let responseHandler: Moya.Completion = { (response) in
                switch response {
                case .success(let result):
                    do {
                        if let parsed = try api.parser.parse(result.data) {
                            results.append(parsed)
                        }
                    } catch {
                        log.error(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
                
                apiCnt -= 1
                if apiCnt <= 0 {
                    log.debug("RESULT: \(results)")
                    completion(results)
                }
            }
            
            //  TODO: Only use else if limitation is
            if api == .google {//  since request are limited
                let token: GTINAPITarget = .getInfo(api, gtin)
                let url = URL(string: "http://www.google.de")!
                gtinBackend.stubRequest(token,
                                        request: URLRequest(url: url),
                                        callbackQueue: DispatchQueue.global(qos: .background),
                                        completion: responseHandler,
                                        endpoint: gtinBackend.endpoint(token),
                                        stubBehavior: StubBehavior.immediate)
            } else {
                gtinBackend.request(.getInfo(api, gtin), completion: responseHandler)
            }
        }
    }
}

