//
//  RequestManager.swift
//  
//
//  Created by Arturo Ventura on 28/10/19.
//

import Foundation
import Alamofire

class MultipartPayload {
    
    enum MimeTypes:String {
        case JPEG = "image/jpeg"
        case MOV  = "video/mov"
    }
    
    private(set) var data: InputStream
    private(set) var name: String
    let mimeType: MimeTypes
    let fileName: String
    private(set) var length: UInt64
    
    init?(imagen:UIImage, name:String) {
        guard let d = imagen.jpegData(compressionQuality: 0.75) else {
            return nil
        }
        self.data = InputStream(data:  d)
        self.length = UInt64(d.count)
        self.name = name
        self.mimeType = .JPEG
        self.fileName = "image.jpeg"
    }
    init?(video:URL, name:String){
        guard let d = InputStream(url: video) else {
            return nil
        }
        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: video.path)[.size] as? NSNumber else {
                return nil
            }
            self.length = fileSize.uint64Value
        }
        catch {
            return nil
        }
        self.data = d
        self.name = name
        self.mimeType = .MOV
        self.fileName = "video.mov"
    }
}

typealias RMResponse = (Decodable?,Int) -> ()
typealias RMError = (Decodable?, CodeResponse, Int) -> ()

/// Clase para realizar peticiones genericas
class RequestManager {
    typealias Metodo = HTTPMethod
    /// crea un request generico con la información proporcionada
    /// - Parameter url: Url a la cual se le hara la petición
    /// - Parameter metodo: Selección de metodo HTTP por utilizar
    /// - Parameter contenido: Contenido que llevara la petición en caso de ser nil no tendra contenido, default nil
    /// - Parameter tipoResultado: Tipo de encodable utilizado para la respuesta, en caso de ser nil, se regresara un success con contenido vacio, default nil
    /// - Parameter delegate: Delegado que recibira las respuestas de la petición
    /// - Parameter tag: Tag que permite operaciones de tipo bandera
    static func generic<A:Encodable, T:Decodable>(url:URL?, metodo:Metodo, contenido:A?, tipoResultado:T.Type?, headers: [String:String]? = nil, tag:Int = 0,multipartsPayload:[MultipartPayload]? = nil, rmResponse: RMResponse? = nil, rmError: RMError? = nil) { // was true
        guard let urlForRequest = url else {
           //print("WRONG URL \(url?.absoluteString ?? "")")
           //print("WRONG URL \(url?.absoluteString ?? "")", to: &LogDestination.shared)
            rmError?(nil, .BAD_URL, tag)
            return
        }
        guard NetworkReachabilityManager()!.isReachable else {
            rmError?(nil, .NOT_CONNECTION, tag)
            return
        }
        var urlRequest:URLRequest = URLRequest(url: urlForRequest)
        urlRequest.httpMethod = metodo.rawValue
        if headers == nil{
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        for header in headers ?? [:]{
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        let dataContenido:Data?
        if let contenido = contenido {
            dataContenido = try? JSONEncoder().encode(contenido)
           //print("Interceptor -> DATA", String(data: dataContenido ?? Data(),encoding: .utf8) ?? "NOT String" )
           //print("Interceptor -> DATA", String(data: dataContenido ?? Data(),encoding: .utf8) ?? "NOT String" , to: &LogDestination.shared)
        } else { dataContenido = nil }
       //print("Interceptor -> URL", url?.absoluteString ?? "NOT String" )
       //print("Interceptor -> URL", url?.absoluteString ?? "NOT String" , to: &LogDestination.shared)
        
        let accion:((_ data: AFDataResponse<Data>) -> (Void)) = { (data: AFDataResponse<Data>) -> (Void)  in
           //print("Interceptor <- DATA", String(data: data.data ?? Data(),encoding: .utf8) ?? "NOT String" )
           //print("Interceptor <- CODE", data.response?.statusCode ?? -1)
           //print("Interceptor <- URL", data.request?.url?.absoluteString ?? -1)
           //print("Interceptor <- RESULT", data.result)
            
           //print("Interceptor <- DATA", String(data: data.data ?? Data(),encoding: .utf8) ?? "NOT String" , to: &LogDestination.shared)
           //print("Interceptor <- CODE", data.response?.statusCode ?? -1, to: &LogDestination.shared)
           //print("Interceptor <- URL", data.request?.url?.absoluteString ?? -1, to: &LogDestination.shared)
           //print("Interceptor <- RESULT", data.result, to: &LogDestination.shared)
            
            guard let response = data.response else {
                rmError?(nil, .UNKNOW, tag)
                return
            }
            let code = CodeResponse(rawValue: response.statusCode) ?? CodeResponse.UNKNOW
            if code == .UNKNOW {
               //print("Code not implemented \(response.statusCode)")
               //print("Code not implemented \(response.statusCode)", to: &LogDestination.shared)
            }
            guard let value = data.data else {
                rmError?(nil, code, tag)
                return
            }
            switch data.result {
            case .success:
                if code == .OK || code == .CREATED {
                    do {
                        let obj = tipoResultado == nil ? nil : try JSONDecoder().decode(tipoResultado!.self, from: value)
                        rmResponse?(obj, tag)
                    }
                    catch _{
                       //print("Falied to decode Json: ",jsonError)
                       //print(String(data:value,encoding: .utf8) ?? "")
                       //print("Falied to decode Json: ",jsonError, to: &LogDestination.shared)
                       //print(String(data:value,encoding: .utf8) ?? "", to: &LogDestination.shared)
                        rmError?(nil, .BAD_DECODABLE, tag)
                    }
                }
                else if code == .SIN_CONTENIDO{
                    rmResponse?(try? JSONDecoder().decode(ErrorPayload.self, from: value),tag)
                } else {
                   //print("Some code \(response.statusCode)")
                   //print("justCode", code)
                   //print("Some code \(response.statusCode)", to: &LogDestination.shared)
                   //print("justCode", code, to: &LogDestination.shared)
                    let obj = tipoResultado == nil ? nil : try? JSONDecoder().decode(ErrorPayload.self, from: value)
                   //print(String.init(data: value, encoding: .utf8) ?? "UNPARSER")
                   //print(String.init(data: value, encoding: .utf8) ?? "UNPARSER", to: &LogDestination.shared)
                    rmError?(obj, code, tag)
                    
                }
            case .failure(_):
               //print("failure")
               //print(error.localizedDescription)
               //print("failure", to: &LogDestination.shared)
               //print(error.localizedDescription, to: &LogDestination.shared)
                /// CUANDO ES TOKEN INVÁLIDO, MANDA A EXTENSIÓN DE LOGOUT DE VIEWCONTROLLER PARA CERRAR SESIÓN
                /// VALIDAR REQUEST MANAGER CON 401
               //print(String.init(data: value, encoding: .utf8) ?? "UNPARSER")
               //print(String.init(data: value, encoding: .utf8) ?? "UNPARSER", to: &LogDestination.shared)
                   //print("Some code \(response.statusCode)")
                   //print("THe code should be \(code)")
                   //print("Some code \(response.statusCode)",to: &LogDestination.shared)
                   //print("THe code should be \(code)", to: &LogDestination.shared)
                let obj = tipoResultado == nil ? nil : try? JSONDecoder().decode(ErrorPayload.self, from: value)
                rmError?(obj, code, tag)
            }
        }
       //print("final ", withAutorization, url?.absoluteURL)
       //print("final ", withAutorization, url?.absoluteURL, to: &LogDestination.shared)
        let FinalSession = AF
        guard let mp = multipartsPayload, !mp.isEmpty else {
            urlRequest.httpBody = dataContenido
            FinalSession.request(urlRequest).validate().responseData(completionHandler: accion) // .validate
            return
        }
        
        
        FinalSession.upload(multipartFormData: { (multipart) in
            if let dataContenido = dataContenido {
                multipart.append(dataContenido, withName:"data")
            }
            mp.forEach { (value:MultipartPayload) in
                multipart.append(value.data, withLength: value.length, name: value.name, fileName: value.fileName, mimeType: value.mimeType.rawValue)
            }
            },with: urlRequest).responseData(completionHandler: accion)
    }
   
    static func generic(url:URL?, metodo:Metodo, headers: [String:String]? = nil, tag:Int = 0, multipartsPayload:[MultipartPayload]? = nil, rmResponse: RMResponse? = nil, rmError: RMError? = nil) {
        let c : DummyCodable? = nil
        let t : DummyCodable.Type? = nil
        self.generic(url: url, metodo: metodo, contenido: c, tipoResultado: t, headers: headers, tag: tag, multipartsPayload:multipartsPayload, rmResponse: rmResponse, rmError: rmError)
    }
    static func generic<A:Encodable>(url:URL?, metodo:Metodo, contenido:A?, headers: [String:String]? = nil, tag:Int = 0, multipartsPayload:[MultipartPayload]? = nil, rmResponse: RMResponse? = nil, rmError: RMError? = nil){
        let t : DummyCodable.Type? = nil
        self.generic(url: url, metodo: metodo, contenido: contenido, tipoResultado: t, headers: headers, tag: tag, multipartsPayload: multipartsPayload, rmResponse: rmResponse, rmError: rmError)
    }
    static func generic<T:Decodable>(url:URL?, metodo:Metodo, tipoResultado:T.Type?, headers: [String:String]? = nil, tag:Int = 0, multipartsPayload:[MultipartPayload]? = nil, rmResponse: RMResponse? = nil, rmError: RMError? = nil) {
        let c : DummyCodable? = nil
        self.generic(url: url, metodo: metodo, contenido: c, tipoResultado: tipoResultado, headers: headers ,tag: tag, multipartsPayload: multipartsPayload, rmResponse: rmResponse, rmError: rmError)
    }
    
    
}
fileprivate class DummyCodable:Codable {}
/// Delegado del Reques manager para recibir la peticiones
protocol RequestManagerDelegate {
    /// Respuesta en caso de exito
    /// - Parameter data: Información que previamente esta Decodeada en el tipo previamente solicitado
    /// - Parameter tag: Tag que permite operaciones de tipo banderas
    func onResponseSuccess(data:Decodable?,tag:Int)
    /// Respuesta en caso de error
    /// - Parameter error: Codigo de error recibido por el servidor o alguno customizado, default Unknow
    /// - Parameter tag: Tag que permite operaciones de tipo banderas
    //func onResponseFailure(error:CodeResponse,tag:Int)
    func onResponseFailure(data:Decodable?, error:CodeResponse, tag:Int)
}

extension RequestManagerDelegate {
    func onResponseSuccess(data:Decodable?,tag:Int) {
       //print("onResponseSuccessful(data:Decodable?,tag:\(tag)) not implemented")
       //print("onResponseSuccessful(data:Decodable?,tag:\(tag)) not implemented", to: &LogDestination.shared)
    }

    func onResponseFailure(data:Decodable?, error:CodeResponse, tag:Int){
        
    }
}
enum CodeResponse: Int {
    case OK = 200
    case CREATED = 201
    case SIN_CONTENIDO = 204
    case AUTHENTICATION_FAILED = 409
    case NOT_FOUND = 404
    case INVALID_TOKEN = 401
    case ERROR_SERVER = 500
    case UNKNOW = -1
    case NOT_CONNECTION = -2
    case BAD_URL = -3
    case BAD_DECODABLE = -4
    case LOGIN_FAILED = 400
}

protocol RequestManagerURIProtocol {
    var RawValue:String {get}
}

// MARK: - ErrorPayload
class ErrorPayload: Codable {
    let cause: String?
    let message: String?
//    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case cause = "cause"
        case message = "message"
//        case timestamp = "timestamp"
    }
    
    init(cause: String?, message: String?) {
        self.cause = cause
        self.message = message
//        self.timestamp = timestamp
    }
}
