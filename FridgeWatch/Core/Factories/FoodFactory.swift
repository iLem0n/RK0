////
////  FoodFactory.swift
////  FridgeWatch
////
////  Created by iLem0n on 03.10.18.
////  Copyright © 2018 Peter Christian Glade. All rights reserved.
////
//
//import Foundation
//
//@available(*, deprecated)
//final class FoodFactory: FoodFactoryType {
//    static func saveFoodItem(_ item: FoodItem) throws {
//        Stores.items.items({
//            switch $0 {
//            case .success(let results):
//                case .failure(let error)
//            }
//           let existingItem = $0.filter({
//                $0.productGTIN == item.productGTIN &&
//                    $0.bestBeforeDate.isSameDay(item.bestBeforeDate) &&
//                    $0.available
//            })
//            .first
//        })
//        
//        
//        
//        if let existingItem = existingItem {
//            store.update(existingItem.id, updateHandler: { (item) in
//                existingItem.amount += item.amount
//            }) { (error) in
//                log.error(error.localizedDescription)
//            }
//        } else {
//            store.insert(item)
//        }
//    }
//}
//
