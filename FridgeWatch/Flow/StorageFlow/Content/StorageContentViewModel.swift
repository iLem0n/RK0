//
//  StorageContentViewModel.swift
//
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift

final class StorageContentViewModel: NSObject, StorageContentViewModelType {
    let message = PublishSubject<Message>()
}
