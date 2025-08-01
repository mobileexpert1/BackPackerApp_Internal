//
//  UserStore.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import Foundation
import Alamofire

protocol UserSearchable{
    func searchUser<T:Codable>(number:String,completion:@escaping ((_ success:Bool,_ result:T?) -> Void))
}

class UserStore: ServiceManager , UserSearchable {
    func searchUser<T>(number: String, completion: @escaping ((Bool, T?) -> Void)) where T : Decodable, T : Encodable {
        
    }
    
    
    static let shared = UserStore()
   
    func loginUser<T: Codable>(
        params: Parameters,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        requestApi(
            ApiConstants.API.LOGIN_USER,
            method: .post,
            parameters: nil,
            httpBody: params.toJsonString()
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }

    
    // API for verifying OTP
    func sendOTP<T: Codable>(
        params: Parameters,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        requestApi(ApiConstants.API.OTP_SEND, method: .post, parameters: params) { (success, result, statusCode) in
            completion(success, result, statusCode)
        }
    }

    // API for resending OTP
    func resendOTP<T: Codable>(
        params: Parameters,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        requestApi(ApiConstants.API.OTP_RESEND, method: .post, parameters: params) { (success, result, statusCode) in
            completion(success, result, statusCode)
        }
    }

    // API for refreshing token
    func refreshToken<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        guard let refreshToken = UserDefaultsManager.shared.refreshToken, !refreshToken.isEmpty else {
            print("⚠️ No refresh token found.")
            completion(false, nil, nil)
            return
        }

        let params: [String: Any] = ["refreshToken": refreshToken]
        let url = ApiConstants.API.REFRESH_TOKEN
        requestApi(url, method: .post, parameters: params) { (success, result, statusCode) in
            completion(success, result, statusCode)
        }
    }

    // API for ChooseRole Type
    func chooseRoleType<T: Codable>(
        params: Parameters,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        guard let bearerToken = UserDefaultsManager.shared.bearerToken, !bearerToken.isEmpty else {
               print("⚠️ No bearerToken found.")
               completion(false, nil, nil)
               return
           }

        let url = ApiConstants.API.SWITCH_ROLE
           let headers = getHeaders()
           requestApi(url, method: .put, parameters: params, headers: headers) { (success, result, statusCode) in
               completion(success, result, statusCode)
           }
    }
    

}

