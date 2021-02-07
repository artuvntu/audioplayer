//
//  GalleryPresenter.swift
//  audioplayer
//
//  Created Arturo Ventura on 04/02/21.
//  Copyright © 2021 ___ORGANIZATIONAME___. All rights reserved.
//

import UIKit

class GalleryPresenter: GalleryPresenterProtocol {
    
    weak var view: GalleryViewControllerProtocol?
    var interactor: GalleryInteractorProtocol?
    var router: GalleryRouterProtocol?

    var currentPage = 1
    
    func viewLoaded() {
        view?.showLoader()
        currentPage = 1
        interactor?.getListGallery(page: currentPage)
    }
    func nextPage() {
        view?.showLoaderPage()
        currentPage += 1
        interactor?.getListGallery(page: currentPage)
    }
    func detailImage(id: String) -> UIViewController? {
        router?.createDetailModule(id: id)
    }
}
extension GalleryPresenter: GalleryInteractorOutputProtocol {
    func onSuccessListGallery(data: GalleryList, page: Int) {
        if page == 1 {
            view?.hideLoader()
            view?.remplaceDataLits(data: data)
        } else {
            view?.hideLoaderPage()
            view?.appendDataList(data: data)
        }
    }
    func onErrorListGalley(page: Int) {
        if page == 0 {
            view?.hideLoader()
        } else {
            view?.hideLoaderPage()
        }
    }
}
