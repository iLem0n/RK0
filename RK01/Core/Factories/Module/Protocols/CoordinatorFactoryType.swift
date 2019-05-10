//
//  CoordinatorFactoryType.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 13.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation

protocol CoordinatorFactoryType {
    static func makeLoginCoordinator(router: RouterType) -> LoginCoordinatorType
    static func makeScanCoordinator() -> (ScanCoordinatorType, RouterType)
    static func makeQuestionCoordinator(router: RouterType) -> QuestionCoordinatorType

}
