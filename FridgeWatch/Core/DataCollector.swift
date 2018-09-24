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

final class DataCollector: NSObject {
    static let shared = DataCollector()

    private var notificationToken: NotificationToken?

    private func startObservingProducts() {
        notificationToken = Realms.shared.objects(Product.self).observe({ (changes) in
            switch changes {
            case .initial(let objects):
                objects.forEach { [weak self] in
                    self?.completeProductInfoIfNeeded($0)
                }
            case .update(let objects, _,_,_):
                break
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
    
    private func updateProductName(_ productID: String) {
        
    }
    
    func test() {
        updateProductName("8718114715162")
    }
    private var request: Cancellable?
    private func updateProductImage(_ productID: String) {
        let target: EndpointTarget = .getImage(productID)
        request = imageProvider.request(target) { (result) in
            let images = target.responseParser(result)
            log.debug(images)
        }
        
    }
    
    //--------------- APIs ------------------
    
}
