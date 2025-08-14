//
//  BackPackerHomeVM.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import Foundation
import UIKit
import Alamofire
class BackPackerHomeVM {
    
    func getBackpackerHomeData(
        lat: Double,
        long: Double,
        completion: @escaping (Bool, BackpackerHomeResponseModel?, String?, Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil, "Authorization token is missing.", nil)
      return
  }

        let url = ApiConstants.API.BACKPACKER_HOME  // e.g., BASE_URL + "api/backpackers/home"
        
        let params: Parameters = [
            "lat": lat,
            "long": long
        ]
        
        let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestValidatedApi(
            url,
            method: .get,
            parameters: params,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<BackpackerHomeResponseModel>, APIError>) in
            switch result {
            case .success(let response, let statusCode):
                completion(true, response?.data, response?.message, statusCode)
            case .failure(let error, let statusCode):
                completion(false, nil, error.customDescription, statusCode)
            }
        }

    }

}

