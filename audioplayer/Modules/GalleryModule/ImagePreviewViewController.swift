//
//  ImagePreviewViewController.swift
//  Hino
//
//  Created by Arturo Ventura on 11/03/20.
//  Copyright © 2020 Sferea. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    static func Instance(image:URL? = nil) -> ImagePreviewViewController {
        let v = ImagePreviewViewController.init()
        v.modalPresentationStyle = .overCurrentContext
        v.url = image
        return v
    }
    var constraintsToClear:[NSLayoutConstraint] = []
    var constraintsHorizontal:[NSLayoutConstraint] = []
    var constraintsVertical:[NSLayoutConstraint] = []
    weak var scroll: UIScrollView!
    weak var image: LoaderImageView!
    var url: URL? {
        willSet {
            image?.cambiarImagen(url: newValue)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let scroll = UIScrollView()
        let image = LoaderImageView()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        scroll.backgroundColor = .clear
        view.addSubview(scroll)
        scroll.fillSuperViewSafeArea()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
        
        scroll.addSubview(image)
        scroll.bouncesZoom = true
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 2
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = true
        
        scroll.delegate = self
        
        image.translatesAutoresizingMaskIntoConstraints = false
        constraintsVertical.append(contentsOf: [
            image.topAnchor.constraint(equalTo: scroll.topAnchor),
            image.bottomAnchor.constraint(equalTo: scroll.bottomAnchor)
        ])
        constraintsHorizontal.append(contentsOf: [
            image.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: scroll.trailingAnchor)
        ])
        constraintsToClear.append(contentsOf: [
            image.centerYAnchor.constraint(equalTo: scroll.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: scroll.centerXAnchor)
        ])
        NSLayoutConstraint.activate(constraintsToClear)
        NSLayoutConstraint.activate(constraintsHorizontal)
        NSLayoutConstraint.activate(constraintsVertical)
        image.backProgressColor = .clear
        image.isUserInteractionEnabled = true
        image.cambiarImagen(url: url)
        image.complitationLoad = {[weak self] (image) in
            guard let self = self else {return}
            NSLayoutConstraint.deactivate(self.constraintsToClear)
            self.view.layoutIfNeeded()
            self.updateMinZoomScaleForSize(self.view.bounds.size,image: image)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TapOutside(_:)))
        scroll.addGestureRecognizer(tap)
        
        self.scroll = scroll
        self.image = image
    }
    func updateMinZoomScaleForSize(_ size: CGSize, image: UIImage? = nil) {
        let imageSize = image?.size ?? self.image.bounds.size
        let widthScale = size.width / imageSize.width
        let heightScale = size.height / imageSize.height
        let minScale = min(widthScale, heightScale)

        scroll.minimumZoomScale = minScale
        scroll.zoomScale = minScale
    }
    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - image.frame.height) / 2)
        let xOffset = max(0, (size.width - image.frame.width) / 2)
        
        self.constraintsVertical.forEach({$0.constant = yOffset})
        self.constraintsHorizontal.forEach({$0.constant = xOffset})
        view.layoutIfNeeded()
    }
    @objc func TapOutside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ImagePreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
      updateConstraintsForSize(view.bounds.size)
    }
}
