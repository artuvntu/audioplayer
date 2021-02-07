//
//  MusicEntity.swift
//  audioplayer
//
//  Created by Arturo Ventura on 05/02/21.
//

import Foundation
import RealmSwift

struct MusicEntityElement: Codable {
    var id: String
    var name: String
    var author: String
    var album: String
    var urlRelative: String
    var downloaded: Bool?
    var urlLocal: String?
    var image: String
}

typealias MusicEntity = [MusicEntityElement]

class MusicRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var album: String = ""
    @objc dynamic var urlRelative: String = ""
    @objc dynamic var downloaded: Bool = false
    @objc dynamic var urlLocal: String = ""
    @objc dynamic var image: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    static func instance(_ music: MusicEntityElement) -> MusicRealm {
        MusicRealm(value: [
            "id": music.id,
            "name": music.name,
            "author": music.author,
            "album": music.album,
            "urlRelative": music.urlRelative,
            "downloaded": music.downloaded ?? false,
            "urlLocal": music.urlLocal ?? "",
            "image": music.image,
        ])
    }
    func toMusic() -> MusicEntityElement {
        MusicEntityElement(
            id: self.id,
            name: self.name,
            author: self.author,
            album: self.album,
            urlRelative: self.urlRelative,
            downloaded: self.downloaded,
            urlLocal: self.urlLocal,
            image: self.image
        )
    }
    func update(_ music: MusicEntityElement) {
        self.id = music.id
        self.name = music.name
        self.author = music.author
        self.album = music.album
        self.urlRelative = music.urlRelative
        self.image = music.image
        if let downloaded = music.downloaded {
            self.downloaded = downloaded
        }
        if let urlLocal = music.urlLocal {
            self.urlLocal = urlLocal
        }
        
    }
}

extension Results where Element: MusicRealm {
    func toMusicEntity() -> MusicEntity {
        self.map({$0.toMusic()})
    }
}

@objcMembers class  VersionEntity: Object, Decodable {
    dynamic var version: String = ""
    dynamic var id:String = ""
    
    override class func primaryKey() -> String? {"id"}
    
    enum CodingKeys: CodingKey {
        case version
    }
    
    
}
