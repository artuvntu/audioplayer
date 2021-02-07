//
//  ProfileInteractor.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileInteractor: ProfileInteractorProtocol {
    
    weak var output: ProfileInteractorOutputProtocol?
    final private let currentUserId = "appRealm.currentUser!.id"

    
    func getUser() {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: UserRealm.self, forPrimaryKey: currentUserId)
            guard let userEntity = user?.toUser() else {
                output?.onFailureUser()
                return
            }
            output?.onSuccessUser(user: userEntity)
        } catch let error {
            print(error)
            output?.onFailureUser()
        }
    }
    
    func saveUser(user: User) {
        do {
            let realm = try Realm()
            try realm.write() {
                if let userPrevius = realm.object(ofType: UserRealm.self, forPrimaryKey: currentUserId) {
                    userPrevius.update(user)
                } else {
                    let userRealm = UserRealm.instance(user,id: currentUserId)
                    realm.add(userRealm)
                }
                output?.onSuccesSaveUser()
            }
        } catch let error {
            print(error)
            output?.onFailureSaveUser()
        }
    }
    
    func saveImageUser(image: UIImage) {
        let data = image.jpegData(compressionQuality: 0)!
        let nameProfileImage = "profileimage.jpeg"
        StoreFile.save(data: data, name: nameProfileImage)
        let url = nameProfileImage
        do {
            let realm = try Realm()
            try realm.write() {
                if let user = realm.object(ofType: UserRealm.self, forPrimaryKey: currentUserId){
                    user.image = url
                } else {
                    realm.add(UserRealm.instance(User(username: "", name: "", image: url, lastName: "", biography: ""), id: currentUserId))
                }
                output?.onSuccesSaveUser()
            }
        } catch let error {
            print(error)
            output?.onFailureSaveUser()
        }
    }
    
   
}
