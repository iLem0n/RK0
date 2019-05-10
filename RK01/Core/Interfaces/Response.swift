//
//  Response.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation

enum ResponseCmd: String {
    case DONE
    case ERROR
    case EXIT
}

protocol ResponseType {}

struct SessionStartResponse: ResponseType {
    let sessionID: String
    
    init(sessionID: String) {
        self.sessionID = sessionID
    }
}

struct DoneResponse: ResponseType {
    let nextStep: Int
    
    init(nextStep: Int) {
        self.nextStep = nextStep
    }
}

struct ErrorResponse: ResponseType {
    let message: String

    init(message: String) {
        self.message = message
    }
}

struct ExitResponse: ResponseType {
    let success: Bool
    let message: String?

    init(success: Bool, message: String?) {
        self.success = success
        self.message = message
    }
}
