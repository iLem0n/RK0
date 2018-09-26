//
//  DataCollector.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Moya
import Freddy
import Result

final class DataCollector: NSObject {
    static let shared = DataCollector()

    private var notificationToken: NotificationToken?

    override init() {
        super.init()
        self.startObservingProducts()
    }
    
    private func startObservingProducts() {
        notificationToken = Realms.shared.objects(Product.self).observe({ (changes) in
            switch changes {
            case .initial(let objects),
                 .update(let objects, _,_,_):
                log.debug("Check for updates on: \(objects)")
                objects.forEach { [weak self] in
                    self?.completeProductInfoIfNeeded($0)
                }
            case .error(let error):
                log.error(error.localizedDescription)
            }
        })
    }
    
    private func completeProductInfoIfNeeded(_ product: Product) {
        if product.name == nil {
            updateProductName(product.gtin)
        }
        
        if product.imageData == nil {
            updateProductImage(product.gtin)
        }
    }
    
    private func updateProductName(_ gtin: String) {
        log.debug(#function)
        log.debug(gtin)
        
        performNameSuche(gtin) { (name) in
            guard let name = name else { return }
            
            let realm = Realms.shared
            try? realm.write {
                let product = realm.object(ofType: Product.self, forPrimaryKey: gtin)
                product?.name = name
            }

        }
    }
    
    private func updateProductImage(_ gtin: String) {
        // set to 'true' when limit is exceeded
        if true {
            performStubGoogleImageSearch(gtin) { (image) in
                guard let image = image else { return }

                let realm = Realms.shared
                try? realm.write {
                    let product = realm.object(ofType: Product.self, forPrimaryKey: gtin)
                    product?.image = image
                }
            }
        } else {
            performGoogleImageSearch(gtin) { (image) in
                guard let image = image else { return }
                let realm = Realms.shared
                try? realm.write {
                    let product = realm.object(ofType: Product.self, forPrimaryKey: gtin)
                    product?.image = image
                }
            }
        }
    }
    
    //------------- GTINSUCHE ---------------
    private func performNameSuche(_ gtin: String, _ completion: @escaping (String?) -> Void) {
        let target: DataSearchTarget = .gtinsuche(gtin)
        
        dataSearchProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                let productData: ProductDataResponse = target.responseParser.parse(response.data) as! ProductDataResponse
                completion(productData.names.first)
            case .failure(let error):
                log.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    //------------- GOOGLE IMAGE SEARCH ---------------
    private func performGoogleImageSearch(_ gtin: String, _ completion: @escaping (UIImage?) -> Void) {
        let target: ImageSearchTarget = .googleImageSearch(gtin)

        imageSearchBackend.request(target) { (result) in
            switch result {
            case .success(let response):
                guard let parsed: ImageResponse = target.responseParser.parse(response.data) as! ImageResponse else { return }
                let largestImage = parsed.images.sorted(by: { $0.area > $1.area }).first
                
                completion(largestImage)
                
            case .failure(let error):
                log.error(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    private func performStubGoogleImageSearch(_ gtin: String, _ completion: @escaping (UIImage?) -> Void) {
        let target: ImageSearchTarget = .googleImageSearch("random")
        
        let url = URL(string: "https://www.googleapis.com/customsearch/v1")
        imageSearchBackend.stubRequest(target, request: URLRequest(url: url!), callbackQueue: DispatchQueue.global(qos: .background), completion: { (result) in
            switch result {
            case .success(let response):
                guard let parsed: ImageResponse = target.responseParser.parse(response.data) as! ImageResponse else { return }
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

extension UIImage {
    var area: CGFloat { return self.size.width * self.size.height }
}
