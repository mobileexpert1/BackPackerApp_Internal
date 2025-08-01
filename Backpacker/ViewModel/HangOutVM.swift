//
//  HangOutVM.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
import UIKit
import Alamofire
import UIKit
import Alamofire

class HangoutViewModel {
    
    func uploadHangout(
        name: String,
        address: String,
        lat: Double,
        long: Double,
        locationText: String,
        description: String,
        image: Data?,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, "Authorization token is missing.",nil)
            return
        }

        let url = ApiConstants.API.ADD_HANGOUT
        
        let params: Parameters = [
            "name": name,
            "address": address,
            "lat": lat,
            "long": long,
            "locationText": locationText,
            "description": description
        ]
        let headers = ServiceManager.sharedInstance.getHeaders()
        ServiceManager.sharedInstance.requestMultipartAPI(
            url,
            image: image,
            method: .post,
            parameters: params,
            headers: headers
        ) { (result:  ApiResult<ApiResponseModel<HangoutResponseData>, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("Upload success")
                completion(true, data?.message ?? "Hangout Added", statusCode)

            case .failure(let error, let statusCode):
                print("Upload failed:", error.localizedDescription)
                completion(false, error.localizedDescription, statusCode)
            }
        }

    }
}

