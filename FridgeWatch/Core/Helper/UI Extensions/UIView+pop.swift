//
//  UIView+pop.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 29.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

extension UIView {
    func makePop(at point: CGPoint) {
                
        let startBounds = CGRect(x:0, y: 0, width: 1, height: 1)
        let endBounds = CGRect(x: -25, y: -25, width: 50, height: 50)
        let duration = 0.5
        
        let circle = CAShapeLayer()
        self.layer.addSublayer(circle)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock {
            circle.removeFromSuperlayer()
        }
        defer { CATransaction.commit() }
        
        circle.fillColor = nil
        circle.strokeColor = UIColor.magenta.cgColor
        circle.lineWidth = 1
        circle.bounds = startBounds
        circle.path = UIBezierPath(arcCenter: point, radius: startBounds.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        let path = UIBezierPath(arcCenter: point, radius: endBounds.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.duration = duration
        colorAnimation.toValue = UIColor.clear.cgColor
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = duration
        pathAnimation.toValue = path.cgPath

        let boundsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.duration = duration
        boundsAnimation.toValue = NSValue(cgRect: endBounds)
        
        let animations = CAAnimationGroup()
        animations.animations = [pathAnimation, boundsAnimation, colorAnimation]
        animations.isRemovedOnCompletion = false
        animations.duration = duration
        animations.fillMode = CAMediaTimingFillMode.removed
        
        circle.add(animations, forKey: nil)
    }
}
