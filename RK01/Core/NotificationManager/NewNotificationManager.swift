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
    }
    
    private func handleItemUpdates(_ nextItems: [FoodItem]) {
        let allItemIDs: [String] = nextItems.map({ $0.id })
        let availableItemIDs: [String] = nextItems.filter({ $0.available }).map({ $0.id })
        let unavailableItemIDs: [String] = nextItems.filter({ !$0.available }).map({ $0.id })
        let itemIDsKey = "itemIDs"
        
        //  check all pending requests for invalid data. reschedule it if neccessary
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] (pendingRequests) in
            guard let strong = self else { return }
            
            log.debug("Pending Requests: \(pendingRequests)")
            //  reschedule requests which contains unavailable itemIDs
            pendingRequests
                .filter { request in    //  returns all requests which contains itemIDs for unavailable items
                    guard let pendingItemIDs = request.content.userInfo[itemIDsKey] as? [String] else { return true }
                    return pendingItemIDs.filter({ unavailableItemIDs.contains($0) }).count > 0
                }
                .forEach { request in   //  remove the request and reschedule with items which are still available
                    guard let pendingItemIDs = request.content.userInfo[itemIDsKey] as? [String] else { return }
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    let stillAvailableItemIDs = pendingItemIDs.filter({ availableItemIDs.contains($0) })
                    if !stillAvailableItemIDs.isEmpty {
                        strong.scheduleNotification(itemIDs: stillAvailableItemIDs, dateComponents: (request.trigger as! UNCalendarNotificationTrigger).dateComponents)
                    }
            }
            
            let unscheduled = availableItemIDs.filter { itemID in
                !pendingRequests.contains { request in
                    let ids: [String] = request.content.userInfo[itemIDsKey] as! [String]
                    return ids.contains(itemID)
                }
            }
            
            self?.scheduleNotification(itemIDs: unscheduled, dateComponents: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(15)))
        }
    }
    
    private func scheduleNotification(itemIDs: [String], dateComponents: DateComponents) {
        log.debug(#function)
        log.debug(itemIDs)        
    }
}

final class FoodItemNotificationContent: UNMutableNotificationContent {
    
    init(productNames: [String], itemIDs: [String], date: Date) {
        super.init()
        
        /*
        self.badge = NSNumber(integerLiteral: itemIDs.count)
        self.title = "You should have a look at your Fridge"
        self.userInfo["itemIDs"] = itemIDs
        
        if productNames.count > 1 {
            self.body = "You should consume thes items: \n"            
        } else {
            self.body = "You should consume \(productNames.first!))"
        }
        */
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
