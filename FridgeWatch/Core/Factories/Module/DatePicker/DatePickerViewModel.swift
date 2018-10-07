//
//  DatePickerViewModel.swift
//
//  FoodWatch
//
//  Created by Peter Christian Glade on 28.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//
import Foundation
import RxSwift

final class DatePickerViewModel: NSObject, DatePickerViewModelType {
    var pickerInitialDate: Date?
    
    var onDatePicked: ((Date?) -> Void)?
    
    let message = PublishSubject<Message>()

    init(date: Date?) {
//        self.save = BehaviorSubject<Date?>(value: date)
        super.init()
    }

    func save(completion: (Date?) -> Void) {
//        guard let date = try? date.value() else { return }
//        completion(date)
    }
}
