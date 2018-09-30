//
//  ProductManager.swift
//  FridgeWatch
//
//  Created by iLem0n on 29.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Moya
import Result

enum ProductManagerError: Error {
    case realmError(Error)
}

final class ProductManager: NSObject {
    public static let shared: ProductManager = ProductManager()
    
    public func getProductData(_ gtin: String, _ productHandler: @escaping (Result<Product, ProductManagerError>) -> Void) {
        if let product = Realms.shared.object(ofType: Product.self, forPrimaryKey: gtin) {
            productHandler(.success(product))
        } else {
            createNewProduct(gtin, productHandler)
        }
    }
    
    private func createNewProduct(_ gtin: String, _ completion: @escaping (Result<Product, ProductManagerError>) -> Void) {
        let new = Product(gtin: gtin)
        // update data before adding
        fetchProductData(new) {
            do {
                //  Add product to realm
                let realm = Realms.shared
                try realm.write {
                    realm.add(new)
                }
                
                completion(.success(new))
            } catch (let error) {
                log.error(error.localizedDescription)
                completion(.failure(.realmError(error)))
            }
        }
    }
    
    private var dataFetchQueue: OperationQueue?
    private func fetchProductData(_ product: Product, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] in
            guard let strong = self else { return }
            let imageSearchOperation = ImageSearchOperation(gtin: product.gtin)
            let dataSearchOperation = DataSearchOperation(gtin: product.gtin)
            
            strong.dataFetchQueue = OperationQueue()
            strong.dataFetchQueue?.addOperation(imageSearchOperation)
            strong.dataFetchQueue?.addOperation(dataSearchOperation)
            
            strong.dataFetchQueue?.waitUntilAllOperationsAreFinished()
            
            product.name = dataSearchOperation.resultName
            product.image = imageSearchOperation.resultImage
            
            log.debug("Completed all requests: \(product)")
            
            completion()
        }
    }
}
