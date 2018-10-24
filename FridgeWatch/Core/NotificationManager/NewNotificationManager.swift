//
//  NewNotificationManager.swift
//  FridgeWatch
//
//  Created by iLem0n on 24.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

final class NewNotificationManager: NSObject {
    static let shared = NewNotificationManager()
    
    private var itemUpdateToken: NotificationToken?
    
    override init() {
        super.init()
        Stores.items.all({
            switch $0 {
            case .success(let itemResults):
                itemUpdateToken = itemResults.observe({ [weak self] in
                    switch $0 {
                    case .initial(let items),
                         .update(let items, _, _, _):
                        self?.handleItemUpdates(items.map({ $0 }))
                    case .error(let error):
                        log.error(error.localizedDescription)
                    }
                })
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        })
    }
    
    private func handleItemUpdates(_ nextItems: [FoodItem]) {
        let allItemIDs: [String] = nextItems.map({ $0.id })
        let availableItemIDs: [String] = nextItems.filter({ $0.available }).map({ $0.id })
        let unavailableItemIDs: [String] = nextItems.filter({ !$0.available }).map({ $0.id })
        
        //  check all pending requests for invalid data. reschedule it if neccessary
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] (pendingRequests) in
            guard let strong = self else { return }
            
            //  reschedule requests which contains unavailable itemIDs
            pendingRequests
                .filter { request in    //  returns all requests which contains itemIDs for unavailable items
                    guard let pendingItemIDs = request.content.userInfo["ItemIDs"] as? [String] else { return true }
                    return pendingItemIDs.filter({ unavailableItemIDs.contains($0) }).count > 0
                }
                .forEach { request in   //  remove the request and reschedule with items which are still available
                    guard let pendingItemIDs = request.content.userInfo["ItemIDs"] as? [String] else { return }
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    let stillAvailableItemIDs = pendingItemIDs.filter({ availableItemIDs.contains($0) })
                    if !stillAvailableItemIDs.isEmpty {
                        strong.scheduleNotification(itemIDs: stillAvailableItemIDs)
                    }
                }
        }
    }
    
    private func scheduleNotification(itemIDs: [String], date: Date) {
        
        Stores.items.getProductNames()
        let formattedDate = DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date)
        
        let content = UNMutableNotificationContent()
        content.badge = NSNumber(integerLiteral: itemIDs.count)
        if itemIDs.count == 1 {
            content.title = "An item needs your attention"
            content.body = "\() could be bad from \(formattedDate)"
        } else if itemIDs.count > 1 {
            content.title = "Some items needs your attention"
            content.body = "The following items could be bad from \(formattedDate)"
        }
        
        
    }
}
