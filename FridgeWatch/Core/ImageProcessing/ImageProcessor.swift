//
//  ImageProcessor.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 14.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class ImageProcessor: NSObject, ImageProcessorType {
    private let queue: OperationQueue = {
        let queue = OperationQueue()

        return queue
    }()
    
    func push(_ image: UIImage) {
        let operation = ImageProcessingOperation(image: image)
        queue.addOperation(operation)
    }
}
