//
//  CMSampleBuffer+image().swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 05.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import AVFoundation
import UIKit

extension CMSampleBuffer {
    func image() -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly);
        defer { CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly) }
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let quartzImage = context.makeImage()
            else { return nil }
        let image = UIImage(cgImage: quartzImage)//.fixedOrientation()
        return image
    }
}


