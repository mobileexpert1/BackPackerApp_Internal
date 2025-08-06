//
//  ProfileVM.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import Foundation
import UIKit
import Alamofire

class ProfileVM {
    
    func getBackPackerProfile<T: Codable>(
        isComeFromUpdate:Bool = false,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, nil,nil)
            return
        }
        let url = ApiConstants.API.BACKPACKER_Profile

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func updateBackPackerProfile<T: Codable>(
        isComeFromUpdate: Bool = false,
        email: String,
        name: String,
        state: String,
        area: String,
        visaType: String,
        notificationStatus: Bool,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, nil, nil)
            return
        }

        let url = ApiConstants.API.BACKPACKER_Profile

        let parameters: Parameters = [
            "email": email,
            "name": name,
            "state": state,
            "area": area,
            "visaType": visaType,
            "notificationStatus": notificationStatus ? "1" : "0"
        ]
 let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .put,
            parameters: parameters,
            headers: headers
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
        
    }

}
