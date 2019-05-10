//
//  ReadFotoViewModel.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift

final class ReadFotoViewModel: NSObject, ReadFotoViewModelType {
    let message = PublishSubject<Message>()
}
