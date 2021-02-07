//
//  JSONRequestManager.swift
//
//
//  Created by Arturo Ventura on 28/10/19.
//

import Foundation


class JSONRequestManager {
    /// crea un request generico con la información proporcionada
    /// - Parameter url: Url a la cual se le hara la petición
    /// - Parameter metodo: Selección de metodo HTTP por utilizar
    /// - Parameter contenido: Contenido que llevara la petición en caso de ser nil no tendra contenido, default nil
    /// - Parameter tipoResultado: Tipo de encodable utilizado para la respuesta, en caso de ser nil, se regresara un success con contenido vacio, default nil
    /// - Parameter delegate: Delegado que recibira las respuestas de la petición
    /// - Parameter tag: Tag que permite operaciones de tipo bandera
    static func generic<A:Encodable, T:Decodable>(url:String, metodo:RequestManager.Metodo, contenido:A?, tipoResultado:T.Type?, delegate:RequestManagerDelegate, tag:Int = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if tipoResultado != nil {
                guard let respuesta:T = JSONRequestManager.encodeJSON(name: url) else {
                    delegate.onResponseFailure(data: nil, error: .UNKNOW, tag: 0)
                    return
                }
                delegate.onResponseSuccess(data: respuesta, tag: tag)
            }else {
                delegate.onResponseSuccess(data: nil, tag: tag)
            }
        }
    }
    static func generic(url:String, metodo:RequestManager.Metodo, delegate:RequestManagerDelegate, tag:Int = 0) {
        let c : DummyCodable? = nil
        let t : DummyCodable.Type? = nil
        self.generic(url: url, metodo: metodo, contenido: c, tipoResultado: t, delegate: delegate, tag: tag)
    }
    static func generic<A:Encodable>(url:String, metodo:RequestManager.Metodo, contenido:A?, delegate:RequestManagerDelegate, tag:Int = 0){
        let t : DummyCodable.Type? = nil
        self.generic(url: url, metodo: metodo, contenido: contenido, tipoResultado: t, delegate: delegate, tag: tag)
    }
    static func generic<T:Decodable>(url:String, metodo:RequestManager.Metodo, tipoResultado:T.Type?, delegate:RequestManagerDelegate, tag:Int = 0) {
        let c : DummyCodable? = nil
        self.generic(url: url, metodo: metodo, contenido: c, tipoResultado: tipoResultado, delegate: delegate, tag: tag)
    }
    static func encodeJSON<T:Decodable>(name:String) -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let actividadData = try JSONDecoder().decode(T.self, from: data)
                return actividadData
            } catch {
               //print("JSONFILEMANAGER:")
               //print(error)
                return nil
            }
        } else {
           //print("JSONFILEMANAGER: Archivo \(name).json not found")
            return nil
        }
    }
}
fileprivate class DummyCodable:Codable {}
