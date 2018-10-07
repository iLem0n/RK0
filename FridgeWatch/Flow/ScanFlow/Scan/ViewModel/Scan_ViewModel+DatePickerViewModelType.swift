//
//  Scan_ViewModel+DatePickerViewModelType.swift
//  FridgeWatch
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

extension Scan_ViewModel: DatePickerViewModelType {
    var pickerInitialDate: Date? {
        guard let dateValue = try? self.dateSubject.value(), let date = dateValue else { return Date() }
        return date
    }
    
    var onDatePicked: ((Date?) -> Void)? {
        return { newDate in
            self.dateSubject.onNext(newDate)
        }
    }
}
