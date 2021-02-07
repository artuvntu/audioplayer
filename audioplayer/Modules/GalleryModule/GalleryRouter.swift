//
//  GalleryRouter.swift
//  audioplayer
//
//  Created Arturo Ventura on 04/02/21.
//  Copyright © 2021 ___ORGANIZATIONAME___. All rights reserved.
//

import UIKit

class GalleryRouter: GalleryRouterProtocol {
    
    weak var presenter: GalleryPresenterProtocol?
    
    static func createModule() -> UIViewController {
        let view = GalleryViewController()
        let presenter: GalleryPresenterProtocol & GalleryInteractorOutputProtocol = GalleryPresenter()
        let interactor:GalleryInteractorProtocol = GalleryInteractor()
        var router: GalleryRouterProtocol = GalleryRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        router.presenter = presenter
        interactor.output = presenter
        
        return view
    }
    
    func createDetailModule(id: String) -> UIViewController {
//        DetailPhotoRouter.createModule(id: id)
        ImagePreviewViewController.Instance(image: URL(string: id))
    }
}
