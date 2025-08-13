//
//  HangOutVM.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
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
        imagesArrayData : [Data],
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
        ServiceManager.sharedInstance.requestMultipartMultiAPI(
            url,
            images: imagesArrayData,
            method: .post,
            parameters: params,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<HangoutResponseData>, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("Hangout uploaded successfully.")
                completion(true, data?.message ?? "Hangout Added", statusCode)

            case .failure(let error, let statusCode):
                print("Hangiut upload failed:", error.localizedDescription)
                completion(false, error.localizedDescription, statusCode)
            }
        }
    }
    
    // MARK: - BackPacker: List of All Accommodation
    func getBackPackerHangoutList<T: Codable>(
        page: Int,
        perPage: Int,
        lat: Double,
        long: Double,
        radius: Int? = nil,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_HANGOUT_URL(
            page: page,
            perPage: perPage,
            lat: lat,
            long: long,
            radius: radius,
            search: search
        )

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    
    
    // MARK: - BackPacker: HangOutDetail
    func getBackPackerHangutDetail<T: Codable>(
        hangoutID:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_HANGOUTDETAIL(hangoutID: hangoutID)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    
    
    //MARK: - Employer Hangout Home Data
    
    
    func getEmployerHangOutHomeData(
        completion: @escaping (Bool, EmployerHangoutData?, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, nil, "Authorization token is missing.", nil)
            return
        }

        let url = ApiConstants.API.EMPLOYER_HANGOUT_HOME  // e.g., BASE_URL + "api/backpackers/home"
        
        let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestValidatedApi(
            url,
            method: .get,
            parameters: nil,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<EmployerHangoutData>, APIError>) in
            switch result {
            case .success(let response, let statusCode):
                completion(true, response?.data, response?.message, statusCode)
            case .failure(let error, let statusCode):
                completion(false, nil, error.customDescription, statusCode)
            }
        }

    }
    
}

