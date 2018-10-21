//
//  NotificationManager.swift
//  FridgeWatch
//
//  Created by iLem0n on 21.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

final class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    private var itemsNotificationToken: NotificationToken?
    
    override init() {
        super.init()
        Stores.items.all({ [weak self] in
            guard let strong = self else { return }
            switch $0 {
            case .success(let results):
                strong.itemsNotificationToken = results.observe({ (changes) in
                    switch changes {
                    case .initial(let objects),
                         .update(let objects, _, _, _):
                        strong.checkNotifications(for: objects.map({ $0.id }))
                    case .error(let error):
                        log.error(error.localizedDescription)
                    }
                })
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        })
    }
    
    private func checkNotifications(for itemIDs: [String]) {
        log.debug(#function)
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { [weak self] (requests) in
            guard let strong = self else { return }
            
            log.debug(requests)
            
            //  remove unavailable item requests
            Stores.items.all({
                switch $0 {
                case .success(let items):
                    items.filter({ !$0.available }).forEach {
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [$0.id])
                    }
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            })
            
            //  schedule unscheduled
            let unscheduledItemIDs = itemIDs.filter({ !requests.map({ $0.identifier }).contains($0) })
            unscheduledItemIDs.forEach {
                strong.scheduleNotification(for: $0)
            }
            
            //  check for invalid scheduled
            requests.forEach { request in
                Stores.items.one(withID: request.identifier, { (itemResult) in
                    switch itemResult {
                    case .success(let item):
                        guard let dateTrigger = request.trigger as? UNCalendarNotificationTrigger,
                            let date = Calendar.current.date(from: dateTrigger.dateComponents)
                        else { return }
                        
                        guard !date.isSameDay(item.bestBeforeDate)  else { return }
                        
                        log.debug("Reschedule")
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [request.identifier])
                        strong.scheduleNotification(for: item.id)
                        
                    case .failure(let error):
                        log.error(error.localizedDescription)
                    }
                })
            }
        })
    }
    
    private func scheduleNotification(for itemID: String) {
        log.debug(#function)
        makeNotificationRequest(for: itemID, {
            guard let request = $0 else { return }
            log.debug("Will add NotificationRequest: \(request)")
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
                guard let error = $0 else { return }
                log.error(error.localizedDescription)
            })
        })
    }
    
    private func makeNotificationRequest(for itemID: String, _ completion: @escaping (UNNotificationRequest?) -> Void) {
        log.debug(#function)
        Stores.items.one(withID: itemID, {
            switch $0 {
            case .success(let item):
                guard item.available else { return }
                let itemDate = item.bestBeforeDate
                
                Stores.products.product(withID: item.productID, {
                    switch $0 {
                    case .success(let product):
                        var comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: itemDate!)
                        comps.hour = 12
                        comps.minute = 00
                        
                        //  TODO: DEV ONLY
                        comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(15))
                        
                        let trigger = UNCalendarNotificationTrigger(
                            dateMatching: comps,
                            repeats: false)
                        
                        let content = UNMutableNotificationContent()
                        content.title = "\(product.name!) is about to go bad"
                        content.body = "You should consume it before \(DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: itemDate!))."
                        content.badge = 1
                        content.sound = UNNotificationSound.default
                        
                        let request = UNNotificationRequest(
                            identifier: itemID,
                            content: content,
                            trigger: trigger)
                        
                        completion(request)
                    case .failure(let error):
                        log.error(error.localizedDescription)
                        completion(nil)
                    }
                })
               
                
            case .failure(let error):
                log.error(error.localizedDescription)
                completion(nil)
            }
        })
    }
    
    
}
