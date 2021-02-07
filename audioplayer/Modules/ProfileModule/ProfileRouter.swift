//
//  ProfileRouter.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ProfileRouter: ProfileRouterProtocol {
    
    weak var presenter: ProfilePresenterProtocol?
    
    static func createModule() -> UIViewController {
        let view = ProfileViewController()
        var presenter: ProfilePresenterProtocol & ProfileInteractorOutputProtocol = ProfilePresenter()
        var interactor:ProfileInteractorProtocol = ProfileInteractor()
        var router: ProfileRouterProtocol = ProfileRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        router.presenter = presenter
        interactor.output = presenter
        
        return view
    }
}
