//
//  CustomImageView.swift
//  Hino
//
//  Created by Arturo Ventura on 12/9/19.
//

import UIKit

class CircularLoaderView: UIView {
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            DispatchQueue.main.async {
                if newValue > 1 {
                    self.circlePathLayer.strokeEnd = 1
                } else if newValue < 0 {
                    self.circlePathLayer.strokeEnd = 0
                } else {
                    self.circlePathLayer.strokeEnd = newValue
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 4
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor(named: "MainLoaderColor")?.cgColor
        layer.addSublayer(circlePathLayer)
        
        progress = 0
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        let circlePathBounds = circlePathLayer.bounds
        circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }
    private var completation: (()-> Void)?
    func reveal(completion: (()-> Void)? = nil) {
        self.completation = completion
        // 1
        backgroundColor = .clear
        progress = 1
        // 2
        circlePathLayer.removeAnimation(forKey: "strokeEnd")
        // 3
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer
        
        // 1
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let finalRadius = sqrt((center.x*center.x) + (center.y*center.y))
        let radiusInset = finalRadius - circleRadius
        let outerRect = circleFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
        let toPath = UIBezierPath(ovalIn: outerRect).cgPath
        
        // 2
        let fromPath = circlePathLayer.path
        let fromLineWidth = circlePathLayer.lineWidth
        
        // 3
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.lineWidth = 2*finalRadius
        circlePathLayer.path = toPath
        CATransaction.commit()
        
        // 4
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2*finalRadius
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath
        // 5
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false

        groupAnimation.delegate = self
        
        circlePathLayer.add(groupAnimation, forKey: "strokeWidth")
    }
}

extension CircularLoaderView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.async {
            self.superview?.layer.mask = nil
            if let f = self.completation {
                f()
            }
        }
        
    }
}
