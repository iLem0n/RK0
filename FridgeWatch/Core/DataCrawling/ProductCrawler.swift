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
import UIKit

final class ProductCrawler: NSObject, FoodCrawlerType {

    static var shared: FoodCrawlerType = ProductCrawler()
    
    func getProductData(_ gtin: String, _ resultHandler: @escaping (Result<Product, FoodCrawlerError>) -> Void) {
        log.debug(#function)
        if let matchingProdcut = Realms.local.object(ofType: Product.self, forPrimaryKey: gtin) {
            if matchingProdcut.name == nil {
                self.updateProductData(gtin) {
                    resultHandler(.failure(.unknownProduct))
                }
            } else {
                resultHandler(.success(matchingProdcut))
            }
            
        } else {
            self.updateProductData(gtin) {
                resultHandler(.failure(.unknownProduct))
            }
        }
    }
    
    func updateProductData(_ gtin: String) {
        updateProductData(gtin, nil)
    }
    
    func updateProductData(_ gtin: String, _ completion: (() -> Void)? = nil) {
        if let product = Realms.local.object(ofType: Product.self, forPrimaryKey: gtin) {
            collectAPIResponses(gtin: gtin) { [weak self] (responses) in
                guard let strong = self else { return }
                
                var namesFound = responses.flatMap({ $0.names })
                var newImage: UIImage? = nil
                
                if product.imageData == nil {
                    newImage = responses.flatMap({ $0.imageUrls }).compactMap({
                        guard let data = try? Data(contentsOf: $0.absoluteURL) else { return nil }
                        return UIImage(data: data)
                    }).first
                }
                
                
                if let existingName = product.name {
                    namesFound.append(existingName)
                }
                
                let realm = Realms.local
                try! realm.write {
                    if let name = strong.suggestName(namesFound) {
                        product.name = name
                    }
                    product.image = newImage
                    log.debug(product)
                }
                completion?()
            }
        } else {
            FoodFactory.makeProduct(gtin) { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.updateProductData(gtin)
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
    private var apis: [API] = [.googleImageSearch, .datakick, .gtinsuche]
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
            
//            if api == .googleImageSearch {//  since request are limited
//                let token: APITarget = .getInfo(api, gtin)
//                let url = URL(string: "http://www.google.de")!
//                searchProviderOld.stubRequest(token,
//                                        request: URLRequest(url: url),
//                                        callbackQueue: DispatchQueue.global(qos: .background),
//                                        completion: responseHandler,
//                                        endpoint: searchProviderOld.endpoint(token),
//                                        stubBehavior: StubBehavior.immediate)
//            } else {
//                searchProviderOld.request(.getInfo(api, gtin), completion: responseHandler)
//            }
        }
    }
}

