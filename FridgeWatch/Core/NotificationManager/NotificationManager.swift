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
        
        getPermissions()
        
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
    
    private func getPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if let error = error {
                log.error(error.localizedDescription)
                return
            }
            
            log.debug("Granted: \(granted)")
        }
    }
    
    private func checkNotifications(for itemIDs: [String]) {
        log.debug(#function)
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { [weak self] (requests) in
            guard let strong = self else { return }
            
            //  remove unavailable item requests
            Stores.items.all({
                switch $0 {
                case .success(let items):
                    requests.forEach { request in
                        guard let activeItemIDs = request.content.userInfo["ItemIDs"] as? [String] else { return }
                        activeItemIDs.forEach {
                            
                        }
                    }
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            })
            
            //  schedule unscheduled
            let unscheduledItemIDs = itemIDs.filter({ !requests.map({ $0.identifier }).contains($0) })
            strong.scheduleNotifications(for: unscheduledItemIDs)
            
            
            //  check for invalid scheduled
            requests.forEach { request in
                Stores.items.one(withID: request.identifier, { (itemResult) in
                    switch itemResult {
                    case .success(let item):
                        guard let dateTrigger = request.trigger as? UNCalendarNotificationTrigger,
                            let date = Calendar.current.date(from: dateTrigger.dateComponents)
                        else { return }
                        
                        guard !date.isSameDay(item.bestBeforeDate)  else { return }
                        
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [request.identifier])
                        strong.scheduleNotifications(for: [item.id])
                        
                    case .failure(let error):
                        log.error(error.localizedDescription)
                    }
                })
            }
        })
    }
    
    private func scheduleNotifications(for itemIDs: [String]) {
        log.debug("\(#function): \(itemIDs)")
        Stores.items.all { [weak self] in
            guard let strong = self else { return }
            
            switch $0 {
            case .success(let itemResults):
                itemResults
                    .filter({ itemIDs.contains($0.id) })
                    .arrangedByDay()
                    .forEach { (itemsByDate: (date: Date, items: [FoodItem])) in
                        let itemIDs: [String] = itemsByDate.items.map({ $0.id })
                        
                        Stores.products.all {
                        switch $0 {
                        case .success(let productResults):
                            let productNames: [String] = productResults
                                .filter({
                                    itemIDs.contains($0.id)
                                })
                                .map({ $0.name })
                                .filter({ $0 != nil })
                                .map({ $0! })
                            
                            guard let request = strong.makeNotificationRequest(notificationID: itemsByDate.items.notificationID, for: productNames, date: itemsByDate.date) else { return }
                            
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                                guard let error = error else { return }
                                log.error(error.localizedDescription)
                            })
                        case .failure(let error):
                            log.error(error.localizedDescription)
                        }
                    }
                }

            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
    
    private func makeNotificationRequest(itemIDs: [String], productNames: [String], date: Date) -> UNNotificationRequest? {
        log.debug(#function)
        var comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        comps.hour = 12
        comps.minute = 00
        
        //  TODO: DEV ONLY
        comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(15))
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: comps,
            repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Some items are about to go bad soon."
        content.body = "You should consume it before \(DateFormatter(timeStyle: .none, dateStyle: .medium).string(from: date))."
        content.badge = NSNumber(integerLiteral: productNames.count)
        content.sound = UNNotificationSound.default
        
        
        productNames.forEach {
            content.title += "\n - \($0)"
        }
        
        let request = UNNotificationRequest(
            identifier: notificationID,
            content: content,
            trigger: trigger)
        
        content.userInfo[]
        return request
    }
}

extension Array where Element: FoodItem {
    func arrangedByDay(_ innerSort: ((FoodItem, FoodItem) -> Bool)? = nil) -> [Date: [FoodItem]] {
        let _innerSort = innerSort ?? { $0.bestBeforeDate < $1.bestBeforeDate }
        var dict: [Date: [FoodItem]] = [:]
        
        log.debug(self)
        for item in self {
            if let existingDateKey = dict.keys.filter({ $0.isSameDay(item.bestBeforeDate) }).first {
                dict[existingDateKey]!.append(item)
            } else {
                dict[item.bestBeforeDate] = [item]
            }
        }
        
        return Dictionary(uniqueKeysWithValues:
            dict.sorted { $0.key < $1.key }
                .map({ ($0.key, $0.value.sorted(by: _innerSort)) })
        )
    }
    
    func arrangeByMonth(_ innerSort: ((FoodItem, FoodItem) -> Bool)? = nil) -> [MonthKey: [FoodItem]] {
        let _innerSort = innerSort ?? { $0.bestBeforeDate < $1.bestBeforeDate }
        var dict: [MonthKey: [FoodItem]] = [:]
        
        for item in self {
            let monthKey = MonthKey(date: item.bestBeforeDate)
            if dict.keys.contains(monthKey) {
                dict[monthKey]!.append(item)
            } else {
                dict[monthKey] = [item]
            }
        }
        
        return Dictionary(uniqueKeysWithValues:
            dict.sorted { $0.key < $1.key }
                .map({ ($0.key, $0.value.sorted(by: _innerSort)) })
        )
    }
}
