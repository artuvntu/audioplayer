//
//  UIViewExtension.swift
//  audioplayer
//
//  Created by Arturo Ventura on 05/02/21.
//

import UIKit

extension UIView {
    
    func fillSuperView(padding: UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints  = false
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor,padding: padding)
    }
    func fillSuperViewSafeArea(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.safeAreaLayoutGuide.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.safeAreaLayoutGuide.trailingAnchor,padding: padding)
    }
    func anchorSize(to view: UIView,by multipler: CGSize = .init(width: 1, height: 1)){
        translatesAutoresizingMaskIntoConstraints  = false
        widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: multipler.width).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: multipler.height).isActive = true
    }
    
    func anchor(centerY: NSLayoutYAxisAnchor?,centerX : NSLayoutXAxisAnchor?){
        translatesAutoresizingMaskIntoConstraints  = false
        if let centerX = centerX{
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY{
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero){
        
        translatesAutoresizingMaskIntoConstraints  = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
    }
    func anchor(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    func anchor(aspectRatio:CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio, constant: 0).isActive = true
    }
    func sameSize(to: UIView, multipler:CGPoint = CGPoint(x: 1, y: 1), constants:CGPoint = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: to, attribute: .height, multiplier: multipler.y, constant: constants.y).isActive = true
        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: to, attribute: .width, multiplier: multipler.x, constant: constants.x).isActive = true
    }
}

extension UIEdgeInsets {
    static let eight = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}
