//
//  ViewModelType.swift
//  Money Monitor
//
//  Created by Peter Christian Glade on 23.06.17.
//  Copyright © 2017 Peter Christian Glade. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModelType: NSObjectProtocol {
    var message: PublishSubject<Message> { get }
}
