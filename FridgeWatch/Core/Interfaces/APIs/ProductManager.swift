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

@available(*, deprecated)
final class ProductManager: NSObject {
    public static let shared: ProductManager = ProductManager()
    
    public func getProductData(_ gtin: String, _ productHandler: @escaping (Result<Product, ProductManagerError>) -> Void) {
//        if let product = Realms.shared.products!.object(ofType: Product.self, forPrimaryKey: gtin) {
//            productHandler(.success(product))
//        } else {
//            createNewProduct(gtin) {
//                let product = Realms.shared.products!.object(ofType: Product.self, forPrimaryKey: gtin)!
//                productHandler(.success(product))
//            }
//        }
    }
    
    private func createNewProduct(_ gtin: String, _ completion: @escaping () -> Void) {
        // update data before adding
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { [weak self] in
//            guard let strong = self else { return }
            let imageSearchOperation = ImageSearchOperation(gtin: gtin)
            let dataSearchOperation = DataSearchOperation(gtin: gtin)
            
            dataFetchQueue = OperationQueue()
            dataFetchQueue?.addOperation(imageSearchOperation)
            dataFetchQueue?.addOperation(dataSearchOperation)
            
            dataFetchQueue?.waitUntilAllOperationsAreFinished()
        
//        
//            do {
//                guard let realm = Realms.shared.products else { fatalError() }
//
//                try realm.write {
//                    
//                    var product = realm.object(ofType: Product.self, forPrimaryKey: gtin)
//                    if product == nil {
//                        product = Product(gtin: gtin)
//                        realm.add(product!)
//                    }
//                    
//                    product!.name = dataSearchOperation.resultName
//                    product!.image = imageSearchOperation.resultImage
//                }
//                completion()
//            } catch (let error) {
//                log.error(error.localizedDescription)
//                completion()
//            }
//        }
    }
    
    private var dataFetchQueue: OperationQueue?
    private func fetchProductData(_ productGTIN: String, _ completion: @escaping () -> Void) {
        
    }
}

