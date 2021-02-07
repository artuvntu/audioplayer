//
//  MusicInteractor.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class MusicInteractor: MusicInteractorProtocol {
        
    weak var output: MusicInteractorOutputProtocol?
    private final let idVersion = "idVersion"

    func getListSongs() {
        if let versionStore = getVersionStore() {
            getVersionRequest {  [weak self, versionStore] (versionRequest) in
                guard let self = self else {return}
                if let versionRequest = versionRequest {
                    print(versionStore.version)
                    print(versionRequest.version)
                    if versionStore.version == versionRequest.version, let musicListStore = self.getMusicListStore() {
                        self.output?.onSuccessSongs(data: musicListStore)
                    } else {
                        self.getUpdateMusicListRequest(versionRequest) { [weak self] (musicListRequest) in
                            guard let self = self else {return}
                            if let musicListRequest = musicListRequest {
                                self.output?.onSuccessSongs(data: musicListRequest)
                            } else {
                                self.output?.onfailureSongs()
                            }
                        }
                    }
                } else {
                    if let musicListStore = self.getMusicListStore() {
                        self.output?.onSuccessSongs(data: musicListStore)
                    } else {
                        self.output?.onfailureSongs()
                    }
                }
            }
        } else {
            getVersionRequest { [weak self] (versionRequest) in
                guard let self = self else {return}
                if let versionRequest = versionRequest {
                    self.getUpdateMusicListRequest(versionRequest) { [weak self] (musicListRequest) in
                        guard let self = self else {return}
                        if let musicListRequest = musicListRequest {
                            self.output?.onSuccessSongs(data: musicListRequest)
                        } else {
                            self.output?.onfailureSongs()
                        }
                    }
                } else {
                    self.output?.onfailureSongs()
                }
            }
        }
    }
    
    func downloadSong(id: String) {
        do {
            let realm = try Realm()
            if let song = realm.object(ofType: MusicRealm.self, forPrimaryKey: id) {
                AF.download(Constants.MusicBase(song.urlRelative)!).responseData { [song, realm, weak output] (response) in
                    switch response.result {
                    case .success(let data):
                        StoreFile.save(data: data, name: song.urlRelative)
                        do {
                            try realm.write {
                                song.downloaded = true
                                song.urlLocal = song.urlRelative
                                output?.onSuccessDownload()
                            }
                        } catch let error {
                            print(error)
                            output?.onFailureDownload()
                            
                        }
                    case .failure(let error):
                        print(error)
                        output?.onFailureDownload()
                    }
                }
                
            }
            
        } catch let error {
            print(error)
        }
    }
    
    private func getVersionStore() -> VersionEntity? {
        do {
            let realm = try Realm()
            let version = realm.object(ofType: VersionEntity.self, forPrimaryKey: idVersion)
            return version
        } catch let error {
            print(error)
        }
        return nil
    }
    
    private func getVersionRequest(response: @escaping (VersionEntity?)->()) {
        RequestManager.generic(url: Constants.MusicListVersion(), metodo: .get, tipoResultado: VersionEntity.self) { [response] (data, tag) in
            if let version = data as? VersionEntity {
                response(version)
            } else {
                response(nil)
            }
        } rmError: { [response] (data, code, tag) in
            response(nil)
        }
    }
    
    private func getMusicListStore() -> MusicEntity? {
        do {
            let realm = try Realm()
            let musicList = realm.objects(MusicRealm.self)
            return musicList.toMusicEntity()
        } catch let error {
            print(error)
        }
        return nil
    }
    
    private func getUpdateMusicListRequest(_ version: VersionEntity, response: @escaping (MusicEntity?) -> ()) {
        RequestManager.generic(url: Constants.MusicList(), metodo: .get, tipoResultado: MusicEntity.self) { [response, weak self] (data, tag) in
            if let musicList = data as? MusicEntity {
                if self?.updateVersionStore(versionNewest: version) ?? false && self?.updateMusicListStore(musicList: musicList) ?? false {
                    print("Store saved")
                }
                response(musicList)
            } else {
                response(nil)
            }
        } rmError: { [response] (data, code, tag) in
            response(nil)
        }
    }
    
    private func updateVersionStore(versionNewest:VersionEntity) -> Bool {
        do {
            let realm = try Realm()
            let version = VersionEntity(value: [
                "version": versionNewest.version,
                "id": idVersion
            ])
            try realm.write { [version] in
                realm.add(version,update: .modified)
            }
            return true
        } catch let error {
            print(error)
        }
        return false
    }
    private func updateMusicListStore(musicList: MusicEntity) -> Bool {
        do {
            let realm = try Realm()
            try realm.write { [musicList] in
                realm.add(musicList.map({MusicRealm.instance($0)}),update: .modified)
            }
            return true
        } catch let error {
            print(error)
        }
        return false
    }
}
