//
//  SetAvailabilityViewModel.swift
//  Backpacker
//
//  Created by Mobile on 04/09/25.
//

import Foundation
import Foundation
import UIKit
import Alamofire

class SetAvailabilityViewModel {
    var responseAvailability: GetAvailabilityResponse?
    
    
    func setAvailability(
        request: AvailabilityRequest,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
        #if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
        #else
        let bearerToken = UserDefaultsManager.shared.bearerToken
        #endif

        guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
            print("⚠️ No refresh token found.")
            completion(false, nil, nil)
            return
        }

        let url = ApiConstants.API.CREATE_AVAILABILITY_FOR_BACKAPACKER

        // Encode the request
        let jsonBody: String
        do {
            let data = try JSONEncoder().encode(request)
            jsonBody = String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            print("⚠️ Failed to encode request: \(error)")
            completion(false, nil, nil)
            return
        }

        print("Request JSON:", jsonBody)
        // Call your generic requestValidatedApi
           ServiceManager.sharedInstance.requestValidatedApiCreateAvailabilty(
               url,
               method: .post,
               parameters: nil,
               httpBody: jsonBody,
               headers: ServiceManager.sharedInstance.getHeaders()
           ) { (result: ApiResult<ApiResponseModel<EmptyData>, APIError>) in
               switch result {
               case .success(let response, let statusCode):
                   completion(response?.success ?? true, response?.message ?? "Something went wrong", statusCode)
               case .failure(let error, let statusCode):
                   completion(false, error.customDescription, statusCode)
               }
           }
        
        // Now pass `jsonBody` as the HTTP body to your request API
    }
    
    
    // MARK: - BackPacker: User Availabilty
    func getUserAvailability<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.GET_BACKAPACKER_AVAILABILITY
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func setOverAllAvaiabilty(
        request : OverAllAvailabilityRequest,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, "Authorization token is missing.", nil)
      return
  }

        let url = ApiConstants.API.UPDATE_OVERALL_AVAILABILITY
       
    
        // Encode the request
        let jsonBody: String
        do {
            let data = try JSONEncoder().encode(request)
            jsonBody = String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            print("⚠️ Failed to encode request: \(error)")
            completion(false, nil, nil)
            return
        }

        print("Request JSON:", jsonBody)
        // Call your generic requestValidatedApi
           ServiceManager.sharedInstance.requestValidatedApiCreateAvailabilty(
               url,
               method: .put,
               parameters: nil,
               httpBody: jsonBody,
               headers: ServiceManager.sharedInstance.getHeaders()
           ) { (result: ApiResult<ApiResponseModel<EmptyData>, APIError>) in
               switch result {
               case .success(let response, let statusCode):
                   completion(response?.success ?? true, response?.message ?? "Something went wrong", statusCode)
               case .failure(let error, let statusCode):
                   completion(false, error.customDescription, statusCode)
               }
           }
    }
}

