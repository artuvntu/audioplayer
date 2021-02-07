//
//  UIViewControllerExtension.swift
//  audioplayer
//
//  Created by Arturo Ventura on 04/02/21.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    func showLoader(){
        
        //        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        //        activityView.center = self.view.center
        //        self.view.addSubview(activityView)
        //        activityView.startAnimating()
        
        let container: UIView = UIView()
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = .clear//UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0),
                                             type: .lineScaleParty,
                                             color: .white,
                                             padding: nil)
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        actInd.backgroundColor = .clear
        loadingView.addSubview(actInd)
        
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        actInd.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        NSLayoutConstraint(item: actInd, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: actInd, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        container.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        self.view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.layoutIfNeeded()
        
        actInd.startAnimating()
        
    }
    
    func hideLoader(){
        guard let viewContainer = self.view.subviews.last else{
            return
        }
        
        guard let indicator = viewContainer.subviews.last?.subviews.last as? NVActivityIndicatorView else{
            return
        }
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        
        viewContainer.removeFromSuperview()
    }

}
extension UIViewController {
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    func enableKeyBoardToggle(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillChangeLogic(isShow: true, keyboardHeight: keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardWillChangeLogic(isShow: false, keyboardHeight: 0)
    }
    
    @objc func keyboardWillChangeLogic(isShow:Bool, keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y = -(isShow ? keyboardHeight : 0)
            self.view.layoutIfNeeded()
        }
    }
    func getFirstResponder(view: UIView?) -> UIView?{
        if view == nil || view!.isFirstResponder {
            return view
        }else {
            var respuesta:UIView? = nil
            for v in view?.subviews ?? [] {
                respuesta = getFirstResponder(view: v)
                if respuesta != nil {
                    break
                }
            }
            return respuesta
        }
    }
}
