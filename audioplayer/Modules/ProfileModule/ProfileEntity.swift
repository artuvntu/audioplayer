//
//  ProfileEntity.swift
//  audioplayer
//
//  Created by Arturo Ventura on 05/02/21.
//

import Foundation
import RealmSwift

struct User: Codable {
    var username, name: String
    var image: String
    var lastName, biography: String
    
    var completeURLImage:String {
        get {
            image.isEmpty ? "" : StoreFile.getFullPath(name: image)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case username, name, image, lastName, biography
    }
    
}

class UserRealm: Object {
    @objc dynamic var username = ""
    @objc dynamic var name = ""
    @objc dynamic var image = ""
    @objc dynamic var lastName = ""
    @objc dynamic var biography = ""
    @objc dynamic var id = ""
    override class func primaryKey() -> String? {
        "id"
    }
    static func instance(_ user: User, id: String) -> UserRealm {
        UserRealm(value: [
            "username" : user.username,
            "name" : user.name,
            "image" : user.image,
            "lastName" : user.lastName,
            "biography" : user.biography,
            "id":id
        ])
    }
    func toUser() ->User {
        User(username: self.username, name: self.name, image: self.image, lastName: self.lastName, biography: self.biography)
    }
    func update(_ user: User) {
        self.username = user.username
        self.name = user.name
        self.lastName = user.lastName
        self.biography = user.biography
        self.image = user.image
    }
}
