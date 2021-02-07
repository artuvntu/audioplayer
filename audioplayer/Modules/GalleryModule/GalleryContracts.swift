//
//  GalleryContracts.swift
//  audioplayer
//
//  Created Arturo Ventura on 04/02/21.
//  Copyright © 2021 ___ORGANIZATIONAME___. All rights reserved.
//

import UIKit
//MARK:- Views
protocol GalleryViewControllerProtocol: UIViewController {
    var presenter: GalleryPresenterProtocol? {get set}
    
    func appendDataList(data: GalleryList)
    func remplaceDataLits(data: GalleryList)
    func showLoaderPage()
    func hideLoaderPage()
}
//MARK:- Interactor
protocol GalleryInteractorProtocol: AnyObject {
    var output: GalleryInteractorOutputProtocol? {get set}
    
    func getListGallery(page:Int)
}

protocol GalleryInteractorOutputProtocol: AnyObject {
    func onSuccessListGallery(data: GalleryList, page: Int)
    func onErrorListGalley(page:Int)
}

//MARK:- Presenter
protocol GalleryPresenterProtocol: AnyObject {
    var view: GalleryViewControllerProtocol? {get set}
    var interactor: GalleryInteractorProtocol? {get set}
    var router: GalleryRouterProtocol? {get set}

    func viewLoaded()
    func nextPage()
    func detailImage(id:String) -> UIViewController?
    
}
//MARK:- Router
protocol GalleryRouterProtocol {
    var presenter: GalleryPresenterProtocol? {get set}
    
    static func createModule() -> UIViewController
    func createDetailModule(id: String) -> UIViewController
}

