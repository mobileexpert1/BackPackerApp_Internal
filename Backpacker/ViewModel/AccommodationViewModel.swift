//
//  AccommodationViewModel.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
import Alamofire
class AccommodationViewModel {
    
//MARK: Add New Accommodation
    func uploadAccommodation(
        name: String,
        address: String,
        lat: Double,
        long: Double,
        locationText: String,
        description: String,
        price: String,
        facilities: [String],
        image: Data?,
        imagesArrayData : [Data],
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, "Authorization token is missing.", nil)
            return
        }

        let url = ApiConstants.API.ADD_ACCOMMODATION // 🔁 Replace with correct endpoint

        var params: Parameters = [
                    "name": name,
                    "address": address,
                    "lat": lat,
                    "long": long,
                    "locationText": locationText,
                    "description": description,
                    "price": price
                ]
        
        // Append array of string correctly as comma-separated string
        if !facilities.isEmpty {
            params["facilities"] = facilities.joined(separator: ",")
        }

        let headers = ServiceManager.sharedInstance.getHeaders()
        ServiceManager.sharedInstance.requestMultipartMultiAPI(
            url,
            images: imagesArrayData,
            method: .post,
            parameters: params,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<AccommodationResponseData>, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("Accommodation uploaded successfully.")
                completion(true, data?.message ?? "Accommodation Added", statusCode)

            case .failure(let error, let statusCode):
                print("Accommodation upload failed:", error.localizedDescription)
                completion(false, error.localizedDescription, statusCode)
            }
        }
        
        
    }
    
    
    // MARK: - BackPacker: List of All Accommodation
    func getAccommodationList<T: Codable>(
        page: Int,
        perPage: Int,
        lat: Double,
        long: Double,
        radius: Int? = nil,
        sortByPrice: String? = nil,
        facilities: String? = nil,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_ACCOMMODATION_URL(
            page: page,
            perPage: perPage,
            lat: lat,
            long: long,
            radius: radius,
            sortByPrice: sortByPrice,
            facilities: facilities,
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

    //MARK: - Backpacker Accomodation detail
    
    // MARK: - BackPacker: JobDetail
    func getBackPackerAcommodationDetail<T: Codable>(
        accommodationID:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_AccomodationDETAIL(accommodationID: accommodationID)
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    
    //MARK: - Emplyer accomodtion Home
    
    func getEmployerAccommodationHomeData(
        completion: @escaping (Bool, EmployerAccommodationData?, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, nil, "Authorization token is missing.", nil)
            return
        }

        let url = ApiConstants.API.EMPLOYER_ACCOMODATION_HOME  // e.g., BASE_URL + "api/backpackers/home"
        
        let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestValidatedApi(
            url,
            method: .get,
            parameters: nil,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<EmployerAccommodationData>, APIError>) in
            switch result {
            case .success(let response, let statusCode):
                completion(true, response?.data, response?.message, statusCode)
            case .failure(let error, let statusCode):
                completion(false, nil, error.customDescription, statusCode)
            }
        }

    }
    
    
    
}
struct AccommodationResponseData: Codable {
    let _id: String
}
