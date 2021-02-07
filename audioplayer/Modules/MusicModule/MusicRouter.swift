//
//  MusicRouter.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class MusicRouter: MusicRouterProtocol {
    
    weak var presenter: MusicPresenterProtocol?
    
    static func createModule() -> UIViewController {
        let view = MusicViewController()
        let presenter: MusicPresenterProtocol & MusicInteractorOutputProtocol = MusicPresenter()
        let interactor:MusicInteractorProtocol = MusicInteractor()
        var router: MusicRouterProtocol = MusicRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        router.presenter = presenter
        interactor.output = presenter
        
        return view
    }

}
