//
//  Constants.swift
//  audioplayer
//
//  Created by Arturo Ventura on 04/02/21.
//

import Foundation

class Constants {
    
    static private var GalleryBaseURL:URLComponents {
        get {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "picsum.photos"
            return urlComponents
        }
    }
    
    static func GalleryList(page:Int, count:Int) -> URL {
        var urlComponents = GalleryBaseURL
        urlComponents.path = "/v2/list"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(count))
        ]
        return try! urlComponents.asURL()
    }
    
    private static let MUSIC_BASE = "http://192.168.0.19:8000/"
//    private static let MUSIC_BASE = "http://localhost:8000/"
    
    static func MusicList() -> URL {
        URL(string: MUSIC_BASE + "musicJson.json")!
    }
    
    static func MusicListVersion() -> URL {
        URL(string: MUSIC_BASE + "version.json")!
    }
    
    static func MusicBase(_ path:String) -> URL? {
        URL(string: MUSIC_BASE + path)
    }
    
}
