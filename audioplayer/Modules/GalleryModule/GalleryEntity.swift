//
//  GalleryEntity.swift
//  audioplayer
//
//  Created by Arturo Ventura on 04/02/21.
//

import Foundation

// MARK: - GalleryListElement
struct GalleryListElement: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

typealias GalleryList = [GalleryListElement]
