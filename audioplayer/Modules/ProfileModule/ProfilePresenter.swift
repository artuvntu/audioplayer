//
//  ProfilePresenter.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?

    func viewLoaded() {
        view?.showLoader()
        interactor?.getUser()
    }
    
    func setUser(_ user: User) {
        view?.showLoader()
        interactor?.saveUser(user: user)
    }
    
    func setImage(_ image: UIImage) {
        view?.showLoader()
        interactor?.saveImageUser(image: image)
    }
    
}
extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func onSuccesSaveUser() {
//        view?.hideLoader()
        interactor?.getUser()
    }
    func onSuccessUser(user: User) {
        view?.hideLoader()
        view?.fillUser(user)
    }
    func onFailureUser() {
        view?.hideLoader()
    }
    func onFailureSaveUser() {
        view?.hideLoader()
    }
}
