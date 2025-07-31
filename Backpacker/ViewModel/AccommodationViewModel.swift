//
//  AccommodationViewModel.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
import Alamofire
class AccommodationViewModel {
    
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

        ServiceManager.sharedInstance.requestMultipartAPI(
            url,
            image: image,
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
}
struct AccommodationResponseData: Codable {
    let _id: String
}
