//
//  PlayerPresenter.swift
//  audioplayer
//
//  Created Arturo Ventura on 06/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerPresenter: PlayerPresenterProtocol {
    
    weak var view: PlayerViewControllerProtocol?
    var interactor: PlayerInteractorProtocol?
    var router: PlayerRouterProtocol?
    var delegateStatus: PlayerStatusDelegate?

    var currentSong: MusicEntityElement?
    var player:AVPlayer?
    
    var currentStatusPlayer: PlayerStatus {
        get {
            delegateStatus?.currentPlayerStatus ?? .none
        }
    }
    
    func viewLoaded() {
        NotificationCenter.default.addObserver(self, selector: #selector(newPlayMusic), name: .changePlayer, object: nil)
    }
    
    @objc func newPlayMusic(_ sender: Notification) {
        
        guard let id = sender.object as? String else {return}
        if id.isEmpty {
            delegateStatus?.setPlayerView(.none)
        } else {
            if delegateStatus?.currentPlayerStatus == .some(.none) {
                delegateStatus?.setPlayerView(.partial)
            }
            interactor?.getSong(id)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func playSong() {
        guard let player = player else {
            view?.changeStatusPlay(false)
            return
        }
        switch player.timeControlStatus {
        case .playing:
            player.pause()
            view?.changeStatusPlay(false)
        case .paused:
            player.play()
            view?.changeStatusPlay(true)
        default:
            view?.changeStatusPlay(false)
        }
    }
    
    private func startToPlay(song: MusicEntityElement) {
        player?.pause()
        player = nil
        guard let url = song.downloaded == true ? URL(fileURLWithPath: StoreFile.getFullPath(name: song.urlLocal!)) : Constants.MusicBase(song.urlRelative) else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            view?.changeStatusPlay(true)
        } catch let error {
            print(error)
        }
    }
    
    func changeStatusView(_ status: PlayerStatus) {
        view?.interfaceComplete(status == .complete)
    }
    
    func previusSong() {
        guard let id = currentSong?.id else {return}
        interactor?.getChangeSong(id, next: false)
    }
    
    func nextSong() {
        guard let id = currentSong?.id else {return}
        interactor?.getChangeSong(id, next: true)
    }
    
}
extension PlayerPresenter: PlayerInteractorOutputProtocol {
    func onSuccessSong(data: MusicEntityElement) {
        self.currentSong = data
        self.view?.fillCurrentSong(data)
        startToPlay(song: data)
    }
    func onFailureSong() {
        
    }
}
