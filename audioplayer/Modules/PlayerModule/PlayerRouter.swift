//
//  PlayerRouter.swift
//  audioplayer
//
//  Created Arturo Ventura on 06/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class PlayerRouter: PlayerRouterProtocol {
    
    weak var presenter: PlayerPresenterProtocol?
    
    static func createModule(delegate: PlayerStatusDelegate?) -> (UIViewController,PlayerPresenterProtocol) {
        let view = PlayerViewController()
        let presenter: PlayerPresenterProtocol & PlayerInteractorOutputProtocol = PlayerPresenter()
        let interactor:PlayerInteractorProtocol = PlayerInteractor()
        var router: PlayerRouterProtocol = PlayerRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.delegateStatus = delegate
        router.presenter = presenter
        interactor.output = presenter
        
        return (view,presenter)
    }
}
