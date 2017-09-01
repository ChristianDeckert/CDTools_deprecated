//
//  CDCircularProgressView
//  redo
//
//  Created by Christian Deckert on 29.01.15.
//  Copyright (c) 2015 Christian Deckert. All rights reserved.
//

import UIKit
import Foundation

open class CDCircularProgressView: UIView {

    fileprivate var hadInitialProgress = false
    var blockAnimation = false
    var ringLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var progressLayer2 = CAShapeLayer()
    var oldProgressLayer = CAShapeLayer()
    var oldProgress: Double = 0.0

    var size = CGSize.zero
    open var duration = 1.0
    open var progressWidth = CGFloat(2.5)
    open var radiusFactor = CGFloat(0.3)
    open var ringStrokeWidthFactor: CGFloat = 4.0
    open var strokeColor = UIColor.white
    
    open var progressColor: UIColor? {
        didSet {
            
            
            if nil != self.superview {
                self.setNeedsLayout()
                self.setNeedsDisplay()
                self.updateConstraintsIfNeeded()
            }
        }
    }

    var currentProgress: Double = 0.0
    open var shouldRedrawAnimated = true
    open var progress: Double = 0.0 {
        willSet {
            self.currentProgress = newValue
            if nil == self.superview {
                self.shouldRedrawAnimated = false
                self.oldProgress = newValue

            } else {
                if newValue != progress {
                    self.shouldRedrawAnimated = true
                } else {
                    self.shouldRedrawAnimated = false
                }
                
                if newValue != progress && progress > 0 {
                    self.oldProgress = progress
                } else {
                    self.oldProgress = 0
                }
            }
        }
        
        didSet {
            
            
            if nil != self.superview {
                self.setNeedsLayout()
                self.setNeedsDisplay()
                self.updateConstraintsIfNeeded()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear

        if nil == self.progressColor {
            self.progressColor = UIColor.black
        }
        
        self.layer.sublayers = nil
        

        let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
        let radius = self.radius()
        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat.pi * 2, clockwise: true)
        
        self.ringLayer.removeFromSuperlayer()
        self.ringLayer.path = nil
        self.ringLayer = CAShapeLayer()
        self.ringLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor //Session.sharedInstance.selectedTintColor().CGColor
        self.ringLayer.lineWidth = ringLineWidth()
        self.ringLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.ringLayer)
        self.ringLayer.path = ring.cgPath
        
        let progressPath = self.pathForProgress(self.currentProgress)
        
        
        let layers = [self.progressLayer, self.progressLayer2]
        for (index, layer) in layers.enumerated() {
            layer.removeFromSuperlayer()
            layer.path = nil
            let newLayer = CAShapeLayer()
            newLayer.fillColor = UIColor.clear.cgColor
            self.layer.addSublayer(newLayer)
            newLayer.path = progressPath.cgPath

            newLayer.opacity = 1.0
            
            if index == 0 {
                self.progressLayer = newLayer
                newLayer.lineWidth = self.progressWidth
                
                newLayer.strokeColor = self.strokeColor.cgColor
            } else {
                self.progressLayer2 = newLayer
                newLayer.lineWidth = self.progressWidth * 0.9
                newLayer.strokeColor = self.progressColor!.cgColor
            }
        }

        self.hadInitialProgress = false

        let increasedProgress = (self.currentProgress > self.oldProgress)
        if !blockAnimation && self.shouldRedrawAnimated && increasedProgress {
            let to = 1.0
            var from = 0.0
            CATransaction.begin()
            
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            if increasedProgress {
                if self.currentProgress > 0 {
                    from = (self.oldProgress) / self.currentProgress
                }
                
                animation.fromValue = from
                animation.toValue = to

            } else {
                if self.oldProgress > 0 {
                    from = (self.progress) / self.oldProgress
                }
                
                animation.fromValue = to
                animation.toValue = from
            }
            animation.duration = self.duration
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
            animation.fillMode = kCAFillModeBoth // keep to value after finishing
            animation.isRemovedOnCompletion = false // don't remove after finishing
            
            CATransaction.setCompletionBlock({ (complete) in
                self.progressLayer.removeAllAnimations()
                self.progressLayer2.removeAllAnimations()
            })
            
            self.progressLayer.add(animation, forKey: animation.keyPath)
            self.progressLayer2.add(animation, forKey: animation.keyPath)
            CATransaction.commit()
        }
        
        self.shouldRedrawAnimated = false
        
    }
    
    fileprivate func pathForProgress(_ progress: Double) -> UIBezierPath {
        let r = self.radius()
        let endAngle = CGFloat.pi * 2 * CGFloat(progress) - (CGFloat.pi/2)
        let progressPath = UIBezierPath(arcCenter: center, radius: r, startAngle: -(CGFloat.pi/2), endAngle: endAngle, clockwise: true)
        return progressPath
    }

    fileprivate func ringLineWidth() -> CGFloat {
        var w = self.progressWidth / self.ringStrokeWidthFactor
        if w < 1.0 {
            w = CGFloat(1.0)
        }
        return w
    }
    
    fileprivate func radius() -> CGFloat {
        let h = self.bounds.size.height
        let w = self.bounds.size.width
        let r = CGFloat ((h > w ? w : h) * self.radiusFactor)
        
        return r
    }
    
    open class func newProgressView(_ frame: CGRect, progress: Double) -> CDCircularProgressView {
        let progressView = CDCircularProgressView(frame: frame)
        progressView.size = frame.size
        progressView.progress = progress
        progressView.hadInitialProgress = true
        
        return progressView
    }

    
    open class func presentInView(_ view: UIView, progressViewToAdd: CDCircularProgressView?, frame: CGRect, progress: Double) -> CDCircularProgressView {
        var progressView: CDCircularProgressView
        if nil == progressViewToAdd {
            progressView = CDCircularProgressView(frame: frame)
        } else {
            progressView = progressViewToAdd!
        }
        progressView.frame = frame
        progressView.size = frame.size
        progressView.progress = progress
        progressView.hadInitialProgress = false
        
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = Array<NSLayoutConstraint>()
        let leading = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        constraints.append(leading)
        let trailing = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0)
        constraints.append(trailing)
        let top = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        constraints.append(top)
        let bottom = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        constraints.append(bottom)
    
        view.addSubview(progressView)
        view.addConstraints(constraints)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        return progressView
    }
    
    open override func fadeIn(completion: (() -> (Void))?) {
    
        super.fade(duration: 0.4, alpha: 1.0, delay: 0.0, completion: { [weak self] () -> (Void) in
            if let s = self {
                s.animate { (Void) -> (Void) in
                    
                }
            }
        })
        
    }
    fileprivate func animate(completion: @escaping (() -> (Void))) {
        
        CATransaction.begin()
        let growAnimation =  CABasicAnimation(keyPath: "strokeEnd")
        growAnimation.duration = self.duration
        growAnimation.fromValue = self.currentProgress
        
        CATransaction.setCompletionBlock(completion)
        self.progressLayer.add(growAnimation, forKey: "strokeEnd")
        self.progressLayer2.add(growAnimation, forKey: "strokeEnd")
        
        CATransaction.commit()
            self.progressLayer.opacity = 1.0
            self.progressLayer2.opacity = 1.0
    }


}
