//
//  PlayerContracts.swift
//  audioplayer
//
//  Created Arturo Ventura on 06/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
//MARK:- Views
protocol PlayerViewControllerProtocol: UIViewController {
    var presenter: PlayerPresenterProtocol? {get set}
    
    func fillCurrentSong(_ song: MusicEntityElement)
    func interfaceComplete(_ complete: Bool)
    func changeStatusPlay(_ isPlaying:Bool)
}
//MARK:- Interactor
protocol PlayerInteractorProtocol: AnyObject {
    var output: PlayerInteractorOutputProtocol? {get set}
    
    func getSong(_ id:String)
    func getChangeSong(_ id:String, next: Bool)
}

protocol PlayerInteractorOutputProtocol: AnyObject {
    func onSuccessSong(data: MusicEntityElement)
    func onFailureSong()
}

//MARK:- Presenter
protocol PlayerPresenterProtocol: AnyObject {
    var view: PlayerViewControllerProtocol? {get set}
    var interactor: PlayerInteractorProtocol? {get set}
    var router: PlayerRouterProtocol? {get set}
    var delegateStatus: PlayerStatusDelegate? {get set}
    
    func viewLoaded()
    func playSong()
    func changeStatusView(_ status: PlayerStatus)
    func previusSong()
    func nextSong()
}
//MARK:- Router
protocol PlayerRouterProtocol {
    var presenter: PlayerPresenterProtocol? {get set}
    static func createModule(delegate: PlayerStatusDelegate?) -> (UIViewController,PlayerPresenterProtocol)
    
}

enum PlayerStatus {
    case complete
    case partial
    case none
}

protocol PlayerStatusDelegate {
    var currentPlayerStatus:PlayerStatus {get}
    func setPlayerView(_ status: PlayerStatus)
}

extension Notification.Name {
    static let changePlayer = Notification.Name("changePlayer")
}
