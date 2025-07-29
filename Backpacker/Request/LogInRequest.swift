//
//  LogInRequest.swift
//  Backpacker
//
//  Created by Mobile on 10/07/25.
//

import Foundation
protocol AppRequest : Codable {

    var asDictionary : [String:Any] { get }
}

extension AppRequest {
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
      }
    
    
}

struct LoginRequest : AppRequest {
    
    var roleType : String
    var mobileNumber : String
    var countryCode : String
    var countryName : String
    var fcmToken : String
    
}

struct OtpRequest: AppRequest, Codable {
    var userId: String
    var otp: String
    var fcmToken: String
    var appVersion: String
    var osType: String
    var osVersion: String
    var deviceBrand: String
    var deviceModel: String
    var deviceId: String
}

struct ResendOtpRequest : AppRequest {
    var userId : String
    
}
struct ChooseRoleTypeRequest : AppRequest {
    var subRoleType : String
    
}
