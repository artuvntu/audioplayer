//
//  ProfileContracts.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
//MARK:- Views
protocol ProfileViewControllerProtocol: UIViewController {
    var presenter: ProfilePresenterProtocol? {get set}
    func fillUser(_ user:User)
}
//MARK:- Interactor
protocol ProfileInteractorProtocol: AnyObject {
    var output: ProfileInteractorOutputProtocol? {get set}
    
    func getUser()
    func saveUser(user: User)
    func saveImageUser(image: UIImage)
    
}

protocol ProfileInteractorOutputProtocol: AnyObject {
    func onSuccessUser(user: User)
    func onFailureUser()
    
    func onSuccesSaveUser()
    func onFailureSaveUser()
}

//MARK:- Presenter
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? {get set}
    var interactor: ProfileInteractorProtocol? {get set}
    var router: ProfileRouterProtocol? {get set}
    
    func viewLoaded()
    func setImage(_ image: UIImage)
    func setUser(_ user: User)
    
}
//MARK:- Router
protocol ProfileRouterProtocol {
    var presenter: ProfilePresenterProtocol? {get set}
    static func createModule() -> UIViewController
    
}

