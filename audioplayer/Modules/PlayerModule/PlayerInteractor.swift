//
//  PlayerInteractor.swift
//  audioplayer
//
//  Created Arturo Ventura on 06/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var output: PlayerInteractorOutputProtocol?

    func getSong(_ id: String) {
        do {
            let realm = try Realm()
            if let song = realm.object(ofType: MusicRealm.self, forPrimaryKey: id) {
                output?.onSuccessSong(data: song.toMusic())
                return
            }
            
        } catch let error {
            print(error)
        }
        output?.onFailureSong()
    }
    func getChangeSong(_ id:String, next: Bool) {
        let delta = next ? 1 : -1
        do {
            let realm = try Realm()
            if let idInt = Int(id), let song = realm.object(ofType: MusicRealm.self, forPrimaryKey: String(idInt + delta)) {
                output?.onSuccessSong(data: song.toMusic())
                return
            }
        } catch let error {
            print(error)
        }
        output?.onFailureSong()
    }
}
