//
//  ServiceManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import Alamofire


typealias Serialization = [String:Any]

struct ApiWrapper{
    
    let items : [Serialization]
    
}

protocol SerializationKey {
    var stringValue:String{get}
}

extension RawRepresentable where RawValue == String {
    var stringValue:String{
        return rawValue
    }
}

protocol SerializationValue {}

extension Bool : SerializationValue{}
extension String : SerializationValue{}
extension Int : SerializationValue{}
extension Dictionary : SerializationValue{}
extension Array : SerializationValue{}



extension Dictionary where Key == String, Value == Any {
    
    func value<V:SerializationValue>(forKey key:SerializationKey) -> V? {
        return self[key.stringValue] as? V
    }
    
}

extension ApiWrapper {
    private enum Keys: String,SerializationKey {
        case items
    }
    
    init(serialization:Serialization) {
        items = serialization.value(forKey: Keys.items) ?? []
    }
}


protocol ApiResource {
    associatedtype Model
    var methodPath:String{get}
    func makeModel(serialization:Serialization) -> Model
}

extension ApiResource {
    
    var url:URL {
        return URL(string:"")!
    }
    
    func makeModel(data:Data) -> [Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {return nil}
        guard let jsonSerialization = json as? Serialization else {return nil}
        let wrapper = ApiWrapper.init(serialization: jsonSerialization)
        return wrapper.items.map(makeModel(serialization:))
        
    }
    
}

protocol NetworkRequest : AnyObject {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data:Data) -> Model?
}

extension NetworkRequest {
    
    fileprivate func load(_ url:URL ,withCompletion completion: @escaping (Model?) -> Void) {
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url) { [weak self](data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        }
        task.resume()
    }
    
}


class ImageRequest {
    let url:URL
    init(url:URL) {
        self.url = url
    }
}

extension ImageRequest : NetworkRequest {
    
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data:data)
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
    
}



class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}


extension ApiRequest : NetworkRequest {
    
    func decode(_ data: Data) -> [Resource.Model]? {
        return resource.makeModel(data: data)
    }
    
    func load(withCompletion completion: @escaping ([Resource.Model]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
    
}


import Alamofire
//import MBProgressHUD

enum Webservice {
    case loginUser
    case uploadGroupPicture
    case verifyUserName
    case verifyLogin
    case createGroup
    case getCountries
    case getConversation
    case getRecentConversationsList
    case getVaultFiles
    case getGroupMembers
    case getGroups
    case getContacts
    case getSecurityImage
    case getuserImage
    case getGroupPicture
    case getGroupName
    case deleteConversation
    case deleteMessage
    case sendMessage
    case deleteuser
    case sendGroupMessage
}


var currentBadgeList = [String:String]()
var badgeListArray = [String]()
import SystemConfiguration

enum ApiResult<T: Codable, U: Error> {
    case success(T?, statusCode: Int)
    case failure(U, statusCode: Int?)
}


enum APIError: Error {
    
    case invalidData
    case jsonDecodingFailure
    case responseUnsuccessful(description: String)
    case decodingTaskFailure(description: String)
    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case postParametersEncodingFalure(description: String)
    case unauthorized                  // 401
    case forbidden                     // 403
    case serverError(code: Int)        // Other status codes
    case customError(message: String)
    var customDescription: String {
        switch self {
        case .requestFailed(let description):
            return "Request failed: \(description)"
        case .invalidData:
            return "Invalid data"
        case .responseUnsuccessful(let description):
            return "Response unsuccessful: \(description)"
        case .jsonDecodingFailure:
            return "JSON decoding failure"
        case .jsonConversionFailure(let description):
            return "JSON conversion failure: \(description)"
        case .decodingTaskFailure(let description):
            return "Decoding task failure: \(description)"
        case .postParametersEncodingFalure(let description):
            return "Parameter encoding failure: \(description)"
        case .unauthorized:
            return "Unauthorized (401): Access token expired"
        case .forbidden:
            return "Forbidden (403): Refresh token expired"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .customError(let message):
                    return message
        }
    }
}
extension APIError: LocalizedError {
    var errorDescription: String? {
        return self.customDescription
    }
}

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401 // refresh
    case unauthorizedToken = 403 // logout
    case methodNotAllowed = 405  // logout
    case internalServerError = 500 // logout
    case unknown

    init(rawValue: Int) {
        switch rawValue {
        case 200: self = .ok
        case 201: self = .created
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 405: self = .methodNotAllowed
        case 500: self = .internalServerError
        default: self = .unknown
        }
    }

    var description: String {
        switch self {
        case .ok: return "Success"
        case .created: return "Created"
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .methodNotAllowed: return "Method Not Allowed"
        case .internalServerError: return "Internal Server Error"
        case .unknown: return "Unknown Status Code"
        case .unauthorizedToken:
            return "Log Out Status Code is 403"
        }
    }
}






let kBaseMessageKey: String = "message"
let kBaseStatusKey: String = "status"
let kBaseResponseKey: String = "response"
let kBaseDataKey: String = "data"

class ServiceManager: NSObject {
    
    let defaultError: String = "Some error has been occured."
    
    public static let sharedInstance = ServiceManager()
    
    var showProgress: Bool = true
    var retry: Int = 0
    var showError = true
    //var progressView : MBProgressHUD? = nil
    
    enum ContentType : String {
        case json = "application/json"
        case urlEncoded = "application/x-www-form-urlencoded"
    }
    
    func toBase64(string:String)->String{
        
        let base64Encoded = Data(string.utf8).base64EncodedString()
        return base64Encoded
        
        
    }
    
    

    @objc func getHeaders() -> [String: String] {
        #if BackpackerHire
        let apiToken = UserDefaultsManager.shared.employerbearerToken
        #else
        let apiToken = UserDefaultsManager.shared.bearerToken
        #endif
        
        guard let token = apiToken else { return [:] }
        
        let httpHeaders = ["Authorization": "Bearer \(token)"]
        print("HEADERS: ", httpHeaders)
        return httpHeaders
    }

}


//MARK: Api parsing methods

var manager = Alamofire.Session.default
extension ServiceManager {
    
    
    func requestUploadApi<T: Codable>(
        _ url: URLConvertible,
        videoData: Data? = nil,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        requestUploadAPI(url, videoData: videoData, method: method, parameters: parameters, httpBody: nil) { (result: ApiResult<T?, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("✅ Upload success. Status code: \(statusCode)")
                completion(true, data ?? nil, statusCode)


            case .failure(let error, let statusCode):
                print("❌ Upload failed. Error: \(error.customDescription), Status code: \(statusCode ?? -1)")
                completion(false, nil, statusCode)
            }
        }
    }
    func requestAsyncApi<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        httpBody: String? = nil,
        headers: [String: String]? = nil,
        showLoader: Bool = true,
        contentType: ContentType = .json
    ) async -> (success: Bool, result: T?, statusCode: Int?) {
        
        return await withCheckedContinuation { continuation in
            requestAPI(
                url,
                method: method,
                parameters: parameters,
                httpBody: httpBody ?? parameters?.toJsonString(),
                headers: headers,
                showLoader: showLoader,
                contentType: contentType
            ) { (result: ApiResult<T?, APIError>) in
                switch result {
                case .success(let wrappedResult, let statusCode):
                    continuation.resume(returning: (true, wrappedResult ?? nil, statusCode))
                case .failure(let error, let statusCode):
                    print("❌ \(error.customDescription)")
                    continuation.resume(returning: (false, nil, statusCode))
                }
            }
        }
    }

    
    
    func requestApi<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        httpBody: String? = nil,
        headers: [String: String]? = nil,
        showLoader: Bool = true,
        contentType: ContentType = .json,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        requestAPI(
            url,
            method: method,
            parameters: parameters,
            httpBody: httpBody ?? parameters?.toJsonString(),
            headers: headers,
            showLoader: showLoader,
            contentType: contentType
        ) { (result: ApiResult<T?, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("✅ API Success – Status Code: \(statusCode), Data: \(String(describing: data))")
                completion(true, data ?? nil, statusCode)

            case .failure(let error, let statusCode):
                print("❌ API Failure – \(error.customDescription), Status Code: \(statusCode ?? -1)")
                completion(true, nil, statusCode)
            }
        }
    }

    func requestValidatedApi<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        httpBody: String? = nil,
        headers: [String: String]? = nil,
        showLoader: Bool = true,
        contentType: ContentType = .json,
        completion: @escaping (ApiResult<ApiResponseModel<T>, APIError>) -> Void
    ) {
        requestAPI(
            url,
            method: method,
            parameters: parameters,
            httpBody: nil,
            headers: headers,
            showLoader: showLoader,
            contentType: contentType
        ) { (result: ApiResult<ApiResponseModel<T>?, APIError>) in
            switch result {
            case .success(let responseModel, let statusCode):
                if let model = responseModel {
                    completion(.success(model, statusCode: statusCode))
                }else{
                    
                }

            case .failure(let error, let statusCode):
                completion(.failure(error, statusCode: statusCode))
            }
        }
    }

    private func requestUploadAPI<T:Codable>(_ url: URLConvertible,videoData:Data? = nil,method:HTTPMethod, parameters: Parameters? = nil,httpBody:String? = nil,headers:[String:String]? = nil, completion: @escaping (ApiResult<T,APIError>) -> Void) {
        print("URL: ",url)
       // //MBProgressHUD.showAdded(to: UIA     pplication.appWindow, animated: true)
      //  self.showLoader()
        do {
            var request = try URLRequest(url: url.asURL())
            request.httpMethod = method.rawValue
            for (key , value) in getHeaders() {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 3600
            configuration.timeoutIntervalForResource = 3600
            manager = Alamofire.Session(configuration: configuration)
            manager.upload(multipartFormData: { (multipartFormData) in
                if parameters != nil {
                    for (key, value) in parameters! {
                        if !(key.contains("upload")){
                            //if (key != "mediaList"){
                            print("key ",key,value)
                            if key == "thumbnail"{
                                print("mediaKey ",key)
                                if let image = (value as? UIImage), let imageData = image.jpegData(compressionQuality: 0.2) {
                                    multipartFormData.append(imageData, withName: key, fileName: "\(key).png", mimeType: "image/png")
                                }
                            }
                            else{
                                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                            }
                        }
                        else{
                            do {
                                print("mediaKey ",key)
                                if let image = (value as? UIImage), let imageData = image.jpegData(compressionQuality: 0.4) {
                                    multipartFormData.append(imageData, withName: key, fileName: "\(key).png", mimeType: "image/png")
                                }
                                else if let videoURl = value as? URL {
                                    multipartFormData.append(videoURl, withName: key, fileName: "\(videoURl.lastPathComponent.replacingOccurrences(of: " ", with: ""))", mimeType: "image/png")
                                }
                                else{
                                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                                }
                            }
                        }
                    }
                }
                if let fileData = videoData {
                    if let fileType = (parameters?["fileType"])as? String {
                        if (fileType == "image"){
                            multipartFormData.append(fileData, withName: "file", fileName: "file.png", mimeType: "image/png")
                        }
                        else{
                            multipartFormData.append(fileData, withName: "file", fileName: "file.mov", mimeType: "video/mov")
                        }
                    }
                }
                
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: request.headers ).responseJSON {[weak self] response1 in
                //AF.request(request).responseJSON(completionHandler: { response1 in
               // //MBProgressHUD.hide(for: UIApplication.appWindow, animated: true)
                
                self?.hideLoader()
                //self?.progressView = nil
                guard let statusCode = response1.response?.statusCode else {
                       completion(.failure(.responseUnsuccessful(description: "No status code received from server"), statusCode: nil))
                       return
                   }
                if let error = response1.error {
                    print("--------- Error -------",error.localizedDescription)
                    if let responseData = response1.data {
                        let htmlString = String(data: responseData, encoding: .utf8)
                        print("Result ",htmlString!)
                        switch URLError.Code(rawValue: error._code) {
                        case .notConnectedToInternet:
                            print("NotConnectedToInternet")
                         //   AlertFactory.showErrorToast(title: error.localizedDescription)
                            return
                        default:
                         //   AlertFactory.showErrorToast(title: "There was an error in the response. Please try again.")
                            break
                        }
                        completion(.failure(.requestFailed(description: error.localizedDescription), statusCode: statusCode))
                        return;
                    }
                }
                else if let data = response1.data{
                    let responseString = String(data: data, encoding: String.Encoding.utf8) as String?
                    print("Response: ",responseString ?? "No response")
                }
                
                
                
                
                
                self?.validateDictionary(url, method: method,parameters: parameters, response1: response1, completion: completion)
            }.uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                // self?.progressView?.progress = Float(progress.fractionCompleted)
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            
        }
        catch{
           // //MBProgressHUD.hide(for: UIApplication.appWindow, animated: true)
            self.hideLoader()

            completion(.failure(.requestFailed(description: error.localizedDescription), statusCode: nil))
        }
        
    }
    func requestMultipartMultiAPI<T: Codable>(
        _ url: URLConvertible,
        images: [Data] = [], // Now supports multiple images
        method: HTTPMethod,
        parameters: Parameters? = nil,
        httpBody: String? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (ApiResult<ApiResponseModel<T>, APIError>) -> Void
    ) {
        print("URL: ", url)
        do {
            var request = try URLRequest(url: url.asURL())
            request.httpMethod = method.rawValue
            for (key, value) in getHeaders() {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 3600
            configuration.timeoutIntervalForResource = 3600
            manager = Alamofire.Session(configuration: configuration)
            
            manager.upload(
                multipartFormData: { multipartFormData in
                    
                    // Append parameters
                    if let params = parameters {
                        for (key, value) in params {
                            if let dataValue = value as? Data {
                                multipartFormData.append(dataValue, withName: key)
                            } else {
                                if let stringValue = "\(value)".data(using: .utf8) {
                                    multipartFormData.append(stringValue, withName: key)
                                }
                            }
                        }
                    }
                    
                    // Append multiple images
                    for (index, imageData) in images.enumerated() {
                        multipartFormData.append(
                            imageData,
                            withName: "images[]", // backend field name (adjust if needed)
                            fileName: "image\(index + 1).jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                    
                },
                to: url,
                usingThreshold: UInt64.init(),
                method: method,
                headers: request.headers
            )
            .responseJSON { [weak self] response1 in
                let statusCode = response1.response?.statusCode
                
                if let error = response1.error {
                    print("--------- Error -------", error.localizedDescription)
                    
                    if let responseData = response1.data {
                        let htmlString = String(data: responseData, encoding: .utf8)
                        print("Result ", htmlString ?? "Unable to decode response")
                        
                        switch URLError.Code(rawValue: error._code) {
                        case .notConnectedToInternet:
                            completion(.failure(.requestFailed(description: "No internet connection"), statusCode: statusCode))
                            return
                        default:
                            break
                        }
                        
                        completion(.failure(.jsonDecodingFailure, statusCode: statusCode))
                        return
                    }
                } else if let data = response1.data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Raw Response: ", responseString ?? "No response string")
                }
                
                if let statusCode = statusCode {
                    do {
                        let decoded = try JSONDecoder().decode(ApiResponseModel<T>.self, from: response1.data!)
                        print("Decoded Success – Status Code: \(statusCode)")
                        
                        if decoded.success == true {
                            completion(.success(decoded, statusCode: statusCode))
                        } else {
                            let apiError: APIError = .responseUnsuccessful(description: decoded.message ?? "Unknown error")
                            completion(.failure(apiError, statusCode: statusCode))
                        }
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(.failure(.decodingTaskFailure(description: error.localizedDescription), statusCode: statusCode))
                    }
                } else {
                    print("No status code found")
                    completion(.failure(.responseUnsuccessful(description: "No status code"), statusCode: nil))
                }
            }
            .uploadProgress(queue: .main) { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            
        } catch {
            self.hideLoader()
            completion(.failure(.requestFailed(description: "\(error.localizedDescription)"), statusCode: nil))
        }
    }

     func requestMultipartAPI<T:Codable>(_ url: URLConvertible,image:Data? = nil,method:HTTPMethod, parameters: Parameters? = nil,httpBody:String? = nil,headers:[String:String]? = nil, completion: @escaping (ApiResult<ApiResponseModel<T>, APIError>) -> Void) {
        print("URL: ",url)
        do {
            var request = try URLRequest(url: url.asURL())
            request.httpMethod = method.rawValue
            for (key , value) in getHeaders() {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 3600
            configuration.timeoutIntervalForResource = 3600
            manager = Alamofire.Session(configuration: configuration)
            manager.upload(multipartFormData: { (multipartFormData) in
                if parameters != nil {
                    for (key, value) in parameters! {
                        if value is Data {
                            
                        } else {
                            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
                }
                if image != nil {
                    multipartFormData.append(image!, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: request.headers ).responseJSON {[weak self] response1 in
                let statusCode = response1.response?.statusCode

                if let error = response1.error {
                    print("--------- Error -------", error.localizedDescription)

                    if let responseData = response1.data {
                        let htmlString = String(data: responseData, encoding: .utf8)
                        print("Result ", htmlString ?? "Unable to decode response")

                        switch URLError.Code(rawValue: error._code) {
                        case .notConnectedToInternet:
                            print("NotConnectedToInternet")
                            completion(.failure(.requestFailed(description: "No internet connection"), statusCode: statusCode))
                            return
                        default:
                            break
                        }

                        completion(.failure(.jsonDecodingFailure, statusCode: statusCode))
                        return
                    }
                } else if let data = response1.data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Raw Response: ", responseString ?? "No response string")
                }

                if let statusCode = statusCode {
                    do {
                        let decoded = try JSONDecoder().decode(ApiResponseModel<T>.self, from: response1.data!)
                        print("Decoded Success – Status Code: \(statusCode)")

                        if decoded.success == true {
                            completion(.success(decoded, statusCode: statusCode))
                        } else {
                            let apiError: APIError = .responseUnsuccessful(description: decoded.message ?? "Unknown error")
                            completion(.failure(apiError, statusCode: statusCode))
                        }
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(.failure(.decodingTaskFailure(description: error.localizedDescription),statusCode: statusCode))
                    }
                } else {
                    print("No status code found")
                    completion(.failure(.responseUnsuccessful(description: "No status code"), statusCode: nil))
                }

            }.uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            
        }
        catch{
            self.hideLoader()
            completion(.failure(.requestFailed(description: "\(error.localizedDescription )"),statusCode: nil))
        }
        
    }
    
    
    
    private func requestAPI<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        httpBody: String? = nil,
        headers: [String: String]? = nil,
        showLoader: Bool = true,
        contentType: ContentType = .json,
        retried: Bool = false, // ⬅️ New parameter to prevent infinite loop
        completion: @escaping (ApiResult<T, APIError>) -> Void
    ) {
        print("📡 URL:", url)

        guard Reachability.isConnectedToNetwork() else {
            UIApplication.showOfflineAlert()
            LoaderManager.shared.hide()
            completion(.failure(.requestFailed(description: "The internet connection appears to be offline."),statusCode: nil))
            return
        }
        do {
            var request = try URLRequest(url: url.asURL())
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(contentType.stringValue, forHTTPHeaderField: "Content-Type")

            // Attach custom headers
            for (key, value) in getHeaders() {
                request.setValue(value, forHTTPHeaderField: key)
            }

            // Encode parameters
            if let parameters = parameters {
                if method == .get {
                    // Encode as query params for GET
                    request = try URLEncoding.queryString.encode(request, with: parameters)
                } else {
                    // Encode as JSON body for POST/PUT/etc
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } else if let httpBody = httpBody {
                // If no parameters, attach raw httpBody if provided
                request.httpBody = httpBody.data(using: .utf8)
            }

            // Debug logging
            print("📨 Headers:", request.allHTTPHeaderFields ?? [:])
            print("📦 Params:", parameters ?? [:])
            print("📬 Method:", method.rawValue)
            if let body = request.httpBody {
                print("📝 Body:", String(data: body, encoding: .utf8) ?? "")
            }

            APIManager.Manager.request(request).responseData { response in
                guard let statusCode = response.response?.statusCode else {
                                completion(.failure(.responseUnsuccessful(description: "No status code received from server"), statusCode: nil))
                                return
                            }


                print("📥 Status Code:", statusCode)

                switch response.result {
                case .success(let data):
                    print("✅ Raw Response:\n", String(data: data, encoding: .utf8) ?? "nil")

                    switch statusCode {
                    case 200...299:
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(decoded, statusCode: statusCode))
                        } catch {
                            print("❌ Decoding Error:", error.localizedDescription)
                            completion(.failure(.jsonDecodingFailure, statusCode: statusCode))
                        }
                    case 400:
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(decoded, statusCode: statusCode))
                        } catch {
                            print("❌ Decoding Error (400):", error.localizedDescription)
                            completion(.failure(.jsonDecodingFailure, statusCode: statusCode))
                        }
                    case 401:
                        // Access token expired — refresh token flow
                        completion(.failure(.unauthorized, statusCode: statusCode))

                    case 403:
                        // Refresh token expired — logout
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                            let nav = UINavigationController(rootViewController: loginVC)
                            nav.navigationBar.isHidden = true
                            UIApplication.shared.windows.first?.rootViewController = nav
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                        completion(.failure(.forbidden, statusCode: statusCode))
                       

                    default:
                        // Other status codes
                        if let jsonString = String(data: data, encoding: .utf8) {
                          
                            if let messageData = jsonString.data(using: .utf8),
                               let messageObj = try? JSONDecoder().decode(MessageResponse.self, from: messageData) {
                                print("API Message:", messageObj.message)
                                completion(.failure(.customError(message: messageObj.message), statusCode: statusCode))
                            } else {
                                completion(.failure(.serverError(code: statusCode), statusCode: statusCode))
                            }
                        } else {
                            completion(.failure(.serverError(code: statusCode), statusCode: statusCode))
                        }

                    }

                case .failure(let error):
                    print("❌ Request Error:", error.localizedDescription)
                    completion(.failure(.requestFailed(description: error.localizedDescription),statusCode: statusCode))
                }
            }

        } catch {
            if showLoader {
                // MBProgressHUD.hide(for: UIApplication.appWindow, animated: true)
            }
            completion(.failure(.requestFailed(description: error.localizedDescription),statusCode: nil))
        }
    }

    /* // Request Api
     private func requestAPI<T: Codable>(
         _ url: URLConvertible,
         method: HTTPMethod,
         parameters: Parameters? = nil,
         httpBody: String? = nil,
         headers: [String: String]? = nil,
         showLoader: Bool = true,
         contentType: ContentType = .json,
         completion: @escaping (ApiResult<T, APIError>) -> Void
     ) {
         print("📡 URL:", url)

         guard Reachability.isConnectedToNetwork() else {
             completion(.failure(.requestFailed(description: "The internet connection appears to be offline.")))
             return
         }

         if showLoader {
             // MBProgressHUD.showAdded(to: UIApplication.appWindow, animated: true)
         }

         do {
             var request = try URLRequest(url: url.asURL())
             request.httpMethod = method.rawValue
             request.httpBody = httpBody?.data(using: .utf8)
             request.addValue("application/json", forHTTPHeaderField: "Accept")
             request.addValue(contentType.stringValue, forHTTPHeaderField: "Content-Type")

             for (key, value) in getHeaders() {
                 request.setValue(value, forHTTPHeaderField: key)
             }

             print("📨 Headers:", request.allHTTPHeaderFields ?? [:])
             print("📦 Params:", parameters ?? [:])
             print("📬 Method:", method.rawValue)

             APIManager.Manager.request(request).responseData { response in
                 if showLoader {
                     // MBProgressHUD.hide(for: UIApplication.appWindow, animated: true)
                 }

                 switch response.result {
                 case .success(let data):
                     print("✅ Raw Response:\n", String(data: data, encoding: .utf8) ?? "nil")

                     do {
                         let decoded = try JSONDecoder().decode(T.self, from: data)
                         completion(.success(decoded))
                     } catch {
                         print("❌ Decoding Error:", error.localizedDescription)
                         completion(.failure(.jsonDecodingFailure))
                     }

                 case .failure(let error):
                     print("❌ Request Error:", error.localizedDescription)
                     completion(.failure(.requestFailed(description: error.localizedDescription)))
                 }
             }

         } catch {
             if showLoader {
                 // MBProgressHUD.hide(for: UIApplication.appWindow, animated: true)
             }
             completion(.failure(.requestFailed(description: error.localizedDescription)))
         }
     }
     */
 
    private func validateDictionary<T: Codable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        response1: AFDataResponse<Any>,
        completion: @escaping (ApiResult<T, APIError>) -> Void
    ) {
        self.getValidDict(result: response1.result) { dict, error, retry in
            let statusCode = response1.response?.statusCode
            print("URL:", url, "\nRESPONSE:", dict as Any)

            guard let response = dict as? [String: Any] else {
                let fallbackMessage = error?.localizedDescription ?? "Something went wrong"
                completion(.failure(.requestFailed(description: fallbackMessage), statusCode: statusCode))
                return
            }

            let isSuccess = response["success"] as? Bool ?? false

            if !isSuccess {
                // Handle error message from "message" or "errors"
                let message = (response["message"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
                let errors = response["errors"] as? [String]
                let firstError = errors?.first?.trimmingCharacters(in: .whitespacesAndNewlines)

                let errorDescription = message?.isEmpty == false ? message! :
                                       firstError?.isEmpty == false ? firstError! :
                                       "Unknown error occurred"

                completion(.failure(.requestFailed(description: errorDescription), statusCode: statusCode))
                return
            }

            // ✅ On success
            if let data = response1.data, response["data"] != nil {
                self.parseResponseData(data: data, statusCode: statusCode,completion: completion)
            } else {
                completion(.success(nil, statusCode: statusCode ?? 200))
            }
        }
    }
/*
 
 private func validateDictionary<T:Codable>(_ url: URLConvertible,method:HTTPMethod, parameters: Parameters? = nil,response1:AFDataResponse<Any>,completion: @escaping (ApiResult<T,APIError>) -> Void){
     self.getValidDict(result: response1.result, completion: {(dict, error, retry) in
         let statusCode = response1.response?.statusCode
         if retry! {
             //  self.requestAPI(url,method:method, parameters: parameters, completion: completion)
             //return
         }
         
         print("URL: ",url,  "RESPONSE: ",dict as Any)
                 
         var dict = dict
         if dict == nil {
             dict = NSDictionary.init(dictionary:
                                         [kBaseMessageKey: error?.localizedDescription ?? "Some error has been occured",
                                          kBaseStatusKey: false])
//                if method == .get {
//                    AlertFactory.showErrorToast(title: "Something Went Wrong")
//                }
//                else{
//                    AlertFactory.showErrorToast(title: error?.localizedDescription ?? "Some error has been occured")
//                }
             completion(.failure(.jsonDecodingFailure,statusCode: statusCode))
         }
         let response = dict as? [String:Any]
         if let type = response?["status"] as? Bool {
             
             if type == false{
                 
                 if let error = response?["error"] as? String{
                     if (response1.request?.url?.absoluteString.contains("verify")) == true && error.contains("Auth failed"){
                         completion(.failure(.requestFailed(description: "Please enter correct code"),statusCode: statusCode))
                     }
                     else{
                         completion(.failure(.requestFailed(description: "\(error)"),statusCode: statusCode))
                     }
                 } else {
                     let error = self.handleError(json: response1.value as AnyObject)
                     completion(.failure(.requestFailed(description: "\(error.localizedDescription)"),statusCode: statusCode))
                 }
                 
             }
             else if type == true , let data = response1.data{
                 if response?["data"] != nil  {
                     self.parseResponseData(data: data, completion: completion)
                     if let message = response?["message"] as? String{
                         if (response1.request?.url!.absoluteString.contains("resendOtp"))!{
                          //   AlertFactory.showSuccessToast(title: message)
                         }
                     }
                 }
                 else {
                     completion(.success(nil, statusCode: statusCode!))
                 }
             }
             
         }
         else{
             completion(.failure(.jsonDecodingFailure,statusCode: statusCode))
         }
         
     })
 }
 
 
 */
    // Validate the response from server and provide respective alerts and responses.

    // Create reesult dictionary dictionary from api response
    private func getValidDict(result: AFResult<Any>, completion: @escaping (_ : NSDictionary?, _ : NSError?, _ : Bool?) -> Void) {
        var dict: NSDictionary!
        switch result {
        case .success(let value):
            dict = value as? NSDictionary
            if dict == nil{
                completion (dict, nil, false)
            }
            else{
                completion (dict, nil, true)
            }
            break
        //success, do anything
        case .failure(let error):
            completion (dict, error as NSError, false)
            break
        }
    }
    
    
    private func parseResponseData<T: Codable>(
        data: Data,
        statusCode: Int? = nil,
        completion: @escaping (ApiResult<T, APIError>) -> Void
    ) {
        do {
            let decoder = JSONDecoder()

            // Try decoding the response using flexible model
            let responseObject = try decoder.decode(ApiResponse<T>.self, from: data)

            // Check success status
            if responseObject.success == false {
                let message = responseObject.message ?? "Something went wrong"
                completion(.failure(.requestFailed(description: message), statusCode: statusCode))
                return
            }

            // If data is required, ensure it's non-nil
            guard let unwrappedData = responseObject.data else {
                completion(.failure(.jsonDecodingFailure, statusCode: statusCode))
                return
            }

            completion(.success(unwrappedData, statusCode: statusCode ?? 200))

        } catch {
            // Print raw JSON if decoding fails
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧨 Raw Response:\n\(jsonString)")
            }

            switch error {
            case let DecodingError.dataCorrupted(context):
                print("🧨 Data corrupted:", context)
                completion(.failure(.responseUnsuccessful(description: parseError(context: context)), statusCode: statusCode))
            case let DecodingError.keyNotFound(key, context):
                print("🧨 Key '\(key)' not found:", context.debugDescription)
                completion(.failure(.responseUnsuccessful(description: parseError(context: context)), statusCode: statusCode))
            case let DecodingError.valueNotFound(value, context):
                print("🧨 Value '\(value)' not found:", context.debugDescription)
                completion(.failure(.responseUnsuccessful(description: parseError(context: context)), statusCode: statusCode))
            case let DecodingError.typeMismatch(type, context):
                print("🧨 Type mismatch '\(type)' –", context.debugDescription)
                completion(.failure(.responseUnsuccessful(description: parseError(context: context)), statusCode: statusCode))
            default:
                print("🧨 General Decoding Error:", error)
                completion(.failure(.responseUnsuccessful(description: error.localizedDescription), statusCode: statusCode))
            }
        }
    }


    
    func parseError(context:DecodingError.Context) -> String {
        return false//CONSTANTS.API.DEBUG_MODE_ON
            ? (context.codingPath.description + context.debugDescription)
            : "There was an error. Please try again."
    }
    
    
    // MARK: - Error helper method
    
    func connectionError(response:AFDataResponse<Any>) -> Bool{
        if (response.error != nil) {
            print((response.error?.localizedDescription)!)
            self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
            return false
        }
        return true
    }
    
    
    func checkErrors(json: AnyObject)  -> Bool{
        if let item = json as? NSDictionary {
            if let status = item["status"] as? Int {
                if Int(status) == 500 {
                    let error = self.handleError(json: json as AnyObject)
                    print(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return false
                }
            }
            else if  item["status"] as? String == "INTERNAL_SERVER_ERROR" {
                return false
            }
        }
        return true
    }
    
    func handleError(json: AnyObject) -> NSError {
        var errorMsg: String = defaultError
        
        if let item = json as? NSArray {
            let itemDict = item[0] as! NSDictionary
            errorMsg = itemDict["errorMessage"] as? String ?? self.defaultError
        } else if let itemDict = json as? NSDictionary{
            if let  error = itemDict["message"] as? String {
                errorMsg = error
            }
            else if let  errorDict = itemDict["message"] as? NSDictionary {
                if let  errorArray = errorDict["email"] as? NSArray , errorArray.count > 0 {
                    if let message = errorArray[0] as? String {
                        errorMsg =  "Email " + message
                    }
                }
            }
            else if let  errorArray = itemDict["error"] as? NSArray , errorArray.count > 0 {
                errorMsg = errorArray[0] as? String ?? self.defaultError
            }
            else  if let  error = itemDict["error"] as? String {
                errorMsg = error
            }
            else{
                errorMsg = itemDict["statusDescription"] as? String ?? self.defaultError
            }
        }
        else{
            errorMsg = "There was an error from server. Please try again."
        }
        let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey as NSObject:errorMsg as AnyObject]
        return NSError(domain: "200", code: 401, userInfo: (userInfo as! [String : Any]))
    }
    
    
    
    func showAlert(title:String,message:String){
        let window :UIWindow = UIApplication.shared.keyWindow!
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
//    func showLoader() {
//        let loader = LoaderVC(nibName: "LoaderVC", bundle: nil)
//        loader.view.tag = 4444
//        
//        if let windowScene = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first(where: { $0.activationState == .foregroundActive }),
//            let window = windowScene.windows.first {
//            
//            window.viewWithTag(4444)?.removeFromSuperview()
//            
//            loader.view.layer.zPosition = .greatestFiniteMagnitude
//            loader.view.frame = window.bounds
//            
//            window.addSubview(loader.view)
//        }
//    }
    func hideLoader() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                let window = windowScene.windows.first {
                
                window.viewWithTag(4444)?.removeFromSuperview()
            }
        }
    }
    
    
}

extension ServiceManager : URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("progress",uploadProgress)
    }
    
}



class APIManager {
    static var Manager: Alamofire.Session = {
        let manager = ServerTrustManager(evaluators: ["backpacker.csdevhub.com": DisabledTrustEvaluator()])
        let session = Session(serverTrustManager: manager)
        
        return session
    }()
}


struct ApiResponse<T: Codable>: Codable {
    var success: Bool
    var data: T?
    var message: String?
    var errors: ErrorModel?

  
}


struct ErrorModel: Codable {
    
}


struct NullResponse: Codable {
    
}

struct MessageResponse: Codable {
    let message: String
}
