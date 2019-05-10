//
//  ResponseFactory.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation

final class ResponseFactory {
    static func parseResponse<T: ResponseType>(_ response: String) -> T {
        let tokens = response.split(separator: ";")
        guard let cmd = ResponseCmd(rawValue: String(tokens[0])) else { fatalError() }
        switch (cmd) {
        case .DONE: return DoneResponse(nextStep: Int(String(tokens[2]))!) as! T
        case .ERROR: return ErrorResponse(message: String(tokens[1])) as! T
        case .EXIT: return ExitResponse(success: Bool(String(tokens[1]))!, message: String(tokens[2])) as! T
        }
    }
}
