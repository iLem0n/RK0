//
//  BehaviorSubject<Bool>+toggle().swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 18.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift

extension BehaviorSubject where Element == Bool {
    func toggle() {
        guard let prev = try? self.value() else { return }
        self.onNext(!prev)
    }
}
