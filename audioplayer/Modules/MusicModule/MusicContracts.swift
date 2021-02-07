//
//  MusicContracts.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
//MARK:- Views
protocol MusicViewControllerProtocol: UIViewController {
    var presenter: MusicPresenterProtocol? {get set}
    
    func fillSongs(data: MusicEntity)
    func selectCurrentPlay()
}
//MARK:- Interactor
protocol MusicInteractorProtocol: AnyObject {
    var output: MusicInteractorOutputProtocol? {get set}

    func getListSongs()
    func downloadSong(id:String)
}

protocol MusicInteractorOutputProtocol: AnyObject {
    func onSuccessSongs(data: MusicEntity)
    func onfailureSongs()
    func onSuccessDownload()
    func onFailureDownload()
}

//MARK:- Presenter
protocol MusicPresenterProtocol: AnyObject {
    var view: MusicViewControllerProtocol? {get set}
    var interactor: MusicInteractorProtocol? {get set}
    var router: MusicRouterProtocol? {get set}

    func viewLoaded()
    func playSong(id:String)
    func downloadSong(id:String)
    func reloadSongs()
    
}
//MARK:- Router
protocol MusicRouterProtocol {
    var presenter: MusicPresenterProtocol? {get set}
    static func createModule() -> UIViewController
    
}

