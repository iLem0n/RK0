//
//  Request.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit

protocol RequestType {
    var payload: String { get }
}

struct StartSessionRequest: RequestType {
    let payload: String
    
    init(name: String) {
        payload = "START;\(name);"
    }
}

struct InitialScanRequest: RequestType {
    let payload: String

    init(sessionID: String, vehicleNumber: String, image: UIImage?) {
        var payload = "NEXT;0;\(sessionID);\(vehicleNumber);"
        if (image != nil) {
            payload += "\(image!.pngData());"
        }
        self.payload = payload
    }
}

struct YesNoRequest: RequestType {
    let payload: String
    
    init(sessionID: String, yesNo: Bool, nextStep: Int = 0, message: String?) {
        var payload = "NEXT;\(nextStep);\(sessionID);\(yesNo ? "y":"n");"
        if (message != nil) {
            payload += "\(message);"
        }
        self.payload = payload
    }
}

struct ScanRequest: RequestType {
    let payload: String
    
    init(sessionID: String, partNumber: String, nextStep: Int = 0, images: [UIImage]?) {
        var payload = "NEXT;\(nextStep);\(sessionID);\(partNumber);"
        if let images = images {
            payload += "\(images.count);"
            for image in images {
                payload += "\(image.pngData());"
            }
        }
        self.payload = payload
    }
}




