//
//  StoreFile.swift
//  audioplayer
//
//  Created by Arturo Ventura on 05/02/21.
//

import Foundation

class StoreFile {
    static func save(data:Data, name: String) {
        let path = append(toPath: self.documentDirectory(), withPathComponent: name)!
        
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        let fileHandle = FileHandle(forWritingAtPath: path)
        fileHandle?.write(data)
    }
    private static func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    private static func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    static func getFullPath(name:String) -> String {
        append(toPath: documentDirectory(), withPathComponent: name) ?? ""
    }
}
