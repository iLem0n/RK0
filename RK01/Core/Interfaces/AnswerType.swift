//
//  AnswerType.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation

enum AnswerKind: String {
    case YN = "yn"
    case scan = "scan"
    case link = "link"
    case ar = "ar"
}

protocol AnswerType {
    var type: AnswerKind { get }
}

struct YesNoAnswer: AnswerType {
    let type: AnswerKind = .YN
    let value: Bool
    
    init(value: Bool) {
        self.value = value
    }
}

