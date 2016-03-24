//
//  WonLineView.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

class WonLineView: UIView {
    
    private var markLayer: CAShapeLayer!
    
    var color: UIColor? = UIColor.redColor() {
        didSet {
            self.markLayer.strokeColor = color?.CGColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func removedLine() {
        self.markLayer.path = nil
        self.markLayer.strokeEnd = (0)
    }
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        path.lineCapStyle = .Square
        self.markLayer.path = path.CGPath
        
        self.markLayer.strokeEnd = (1)
        
        let checkMarkAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkMarkAnimation.duration = 0.3
        checkMarkAnimation.removedOnCompletion = false
        checkMarkAnimation.fillMode = kCAFillModeBoth
        checkMarkAnimation.fromValue = (0)
        checkMarkAnimation.toValue = (1)
        checkMarkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        self.markLayer.addAnimation(checkMarkAnimation, forKey: "strokeEnd")
        
        self.setNeedsDisplay()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        
        self.markLayer = CAShapeLayer()
        self.markLayer.fillColor = nil
        self.markLayer.strokeColor = self.color?.CGColor
        self.markLayer.lineWidth = 15
        self.markLayer.strokeEnd = 1.0
        
        self.markLayer.shadowColor = UIColor.blackColor().CGColor
        self.markLayer.shadowOpacity  = 0.9
        self.markLayer.shadowOffset = CGSizeMake(5.0, 5.0)
        
        self.layer.addSublayer(self.markLayer)
    }
    
}