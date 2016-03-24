//
//  MarkView.swift
//  TicTacToe
//
//  Created by Andrii Kurshyn on 3/12/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

import UIKit

class MarkView: UIView {
    
    var color: UIColor? = UIColor.greenColor() {
        didSet {
            self.markLayer.strokeColor = color?.CGColor
        }
    }
    
    var gameMark: GameMark? {
        didSet {
            self.markLayer.path = self.markPath()
        }
    }
    
    private var markLayer: CAShapeLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.gameMark != nil && self.gameMark != .Empty {
            self.markLayer.path = self.markPath()
        }
    }
    
    // MARK: Public methods
    func setGameMark(gameMark: GameMark, animated: Bool) {
        
        if gameMark == self.gameMark {
            return
        }
        self.gameMark = gameMark
        
        self.markLayer.path = self.markPath()
        
        self.markLayer.strokeEnd = (1)
        
        if animated == true {
            let checkMarkAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            checkMarkAnimation.duration = 0.3
            checkMarkAnimation.removedOnCompletion = false
            checkMarkAnimation.fillMode = kCAFillModeBoth
            checkMarkAnimation.fromValue = (0)
            checkMarkAnimation.toValue = (1)
            checkMarkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            checkMarkAnimation.removedOnCompletion = true
            
            self.markLayer.addAnimation(checkMarkAnimation, forKey: "strokeEnd")
        }
        
        self.setNeedsDisplay()
    }
    
    // MARK: Private method
    private func commonInit() {
        self.backgroundColor = UIColor.clearColor()
        
        self.markLayer = CAShapeLayer()
        self.markLayer.path = self.markPath()
        self.markLayer.fillColor = nil
        self.markLayer.strokeColor = self.color?.CGColor
        self.markLayer.lineWidth = 6
        self.markLayer.strokeEnd = 0.0
        
        self.markLayer.shadowColor = UIColor.blackColor().CGColor
        self.markLayer.shadowOpacity  = 0.6
        self.markLayer.shadowOffset = CGSizeMake(0.0, 2.0)
        
        self.layer.addSublayer(self.markLayer)
    }
    
    private func markPath() -> CGPath? {
        
        let rect = self.bounds
        let bezierPath = UIBezierPath()
        
        if self.gameMark == .Circle {
            
            let center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0)
            
            let diameter = min(rect.size.width, rect.size.height)
            
            let radius = diameter / 2.0
            
            bezierPath.addArcWithCenter(center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
            bezierPath.lineCapStyle = .Square
        }
        
        if self.gameMark == .Cross {
            
            let checkMarkPath = UIBezierPath()
            checkMarkPath.moveToPoint(CGPointMake( 0.0, 0.0))
            checkMarkPath.addLineToPoint(CGPointMake(rect.width, rect.height))
            
            checkMarkPath.moveToPoint(CGPointMake( rect.width, 0.0))
            checkMarkPath.addLineToPoint(CGPointMake(0.0, rect.height))
            
            checkMarkPath.lineCapStyle = .Square
            return checkMarkPath.CGPath
        }
        
        return bezierPath.CGPath
        
    }
    
}

