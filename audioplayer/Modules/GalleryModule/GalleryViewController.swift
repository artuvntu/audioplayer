//
//  GalleryViewController.swift
//  audioplayer
//
//  Created Arturo Ventura on 04/02/21.
//  Copyright © 2021 ___ORGANIZATIONAME___. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,GalleryViewControllerProtocol {
        
    var presenter: GalleryPresenterProtocol?
    var items: GalleryList?
    
    lazy var photosCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 83, right: 0)
        collection.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
        return collection
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(named: "MainBackground")
        view.addSubview(photosCollection)
        photosCollection.fillSuperViewSafeArea()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
    }
    
    func appendDataList(data: GalleryList) {
        items?.append(contentsOf: data)
        photosCollection.reloadData()
    }
    
    func remplaceDataLits(data: GalleryList) {
        items = data
        photosCollection.reloadData()
    }
    
    func showLoaderPage() {
        
    }
    
    func hideLoaderPage() {
        
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        GalleryCollectionViewCell.fillCell(collectionView: collectionView, indexPath: indexPath, data: items![indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let commonSize = (UIScreen.main.bounds.width / 3) - 8
        return CGSize(width: commonSize, height: commonSize)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = presenter?.detailImage(id: items![indexPath.row].downloadURL) else {return}
        self.present(vc, animated: true, completion: nil)
    }
}


class GalleryCollectionViewCell: UICollectionViewCell {
    
    static func fillCell(collectionView: UICollectionView, indexPath: IndexPath, data: GalleryListElement) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCollectionViewCell else { fatalError("GalleryCollectionViewCell isn't register")}
        cell.imageView.cambiarImagen(url: URL(string: data.downloadURL))
        return cell
    }
    
    lazy var imageView:LoaderImageView = {
        let image = LoaderImageView()
        addSubview(image)
        image.fillSuperView(padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        image.layer.cornerRadius = 8
        image.backgroundColor = UIColor.systemGray
        image.backProgressColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
}
