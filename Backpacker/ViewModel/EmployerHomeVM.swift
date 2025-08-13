//
//  EmployerHomeVM.swift
//  BackpackerHire
//
//  Created by Mobile on 13/08/25.
//

import Foundation
import Alamofire
class EmployerHomeVM {
    
    func getEmployerHomeData(
        completion: @escaping (Bool, EmployerHomeData?, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, nil, "Authorization token is missing.", nil)
            return
        }

        let url = ApiConstants.API.EMPLOYER_HOME  // e.g., BASE_URL + "api/backpackers/home"
        
        let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestValidatedApi(
            url,
            method: .get,
            parameters: nil,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<EmployerHomeData>, APIError>) in
            switch result {
            case .success(let response, let statusCode):
                completion(true, response?.data, response?.message, statusCode)
            case .failure(let error, let statusCode):
                completion(false, nil, error.customDescription, statusCode)
            }
        }

    }

}
