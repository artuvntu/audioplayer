//
//  CustomImageView.swift
//  Hino
//
//  Created by Arturo Ventura on 12/9/19.
//

import UIKit
import SDWebImage

class LoaderImageView: UIImageView {
    
    let progressIndicatorView = CircularLoaderView(frame: .zero)
    var backProgressColor = UIColor.clear {
        willSet {
            progressIndicatorView.backgroundColor = newValue
        }
    }
    private var options = SDWebImageOptions.fromLoaderOnly
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        configurate()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurate()
    }
    func configurate(){
        addSubview(progressIndicatorView)
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .init(rawValue: 0),
            metrics: nil, views: ["v": progressIndicatorView]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .init(rawValue: 0),
            metrics: nil, views:  ["v": progressIndicatorView]))
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicatorView.backgroundColor = backProgressColor
    }
    func cambiarImagen(url: URL?, placeholderImage: UIImage? = nil) {
        self.progressIndicatorView.progress = 0.1
        sd_setImage(with: url, placeholderImage: placeholderImage, options: options, progress:
                        { [weak self] receivedSize, expectedSize, _ in
                            self?.progressIndicatorView.progress = CGFloat(receivedSize) / CGFloat(expectedSize)
                        }) { [weak self] image, error, f, _ in
            if let error = error {
                print(error)
            }
            if self?.options == .fromLoaderOnly {
                self?.complitationLoad?(image)
                self?.progressIndicatorView.reveal()
                self?.options = .refreshCached
            }
        }
    }
    var complitationLoad:((UIImage?)->Void)?
}
