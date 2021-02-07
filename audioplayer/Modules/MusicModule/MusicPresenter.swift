//
//  MusicPresenter.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class MusicPresenter: MusicPresenterProtocol {
    weak var view: MusicViewControllerProtocol?
    var interactor: MusicInteractorProtocol?
    var router: MusicRouterProtocol?

    func viewLoaded() {
        reloadSongs()
    }
    
    func reloadSongs() {
        view?.showLoader()
        interactor?.getListSongs()
    }
    
    func playSong(id: String) {
        NotificationCenter.default.post(name: .changePlayer, object: id)
    }
    
    func downloadSong(id: String) {
        interactor?.downloadSong(id: id)
    }
    
}
extension MusicPresenter: MusicInteractorOutputProtocol {
    func onSuccessSongs(data: MusicEntity) {
        view?.hideLoader()
        view?.fillSongs(data: data)
    }
    func onfailureSongs() {
        view?.hideLoader()
    }
    func onSuccessDownload() {
        interactor?.getListSongs()
    }
    func onFailureDownload() {
        
    }
}
