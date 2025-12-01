//
//  SubscriptionViewModel.swift
//  Backpacker
//
//  Created by Mobile on 06/10/25.
//

import Foundation
import Alamofire

class SubscriptionViewModel {
    
    
    func getlistOfSubscriptions<T: Codable>(regionCode:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.GET_LISTOF_SUBSCRIPTIONSNEW(platform: "ios", country: regionCode)
   
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func createUserPlanAfterPurchase(
        purchaseInfo: CreateUserPlanRequest,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
        #if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
        #else
        let bearerToken = UserDefaultsManager.shared.bearerToken
        #endif

        guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
            print("⚠️ No bearer token found.")
            completion(false, nil, nil)
            return
        }

        let url = ApiConstants.API.CREATE_NEW_USER_PLAN // replace with actual API

        // Encode purchaseInfo to JSON
        let jsonBody: String
        do {
            let data = try JSONEncoder().encode(purchaseInfo)
            jsonBody = String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            print("⚠️ Failed to encode request: \(error)")
            completion(false, nil, nil)
            return
        }

        print("Request JSON:", jsonBody)

        // Call your generic request
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
    }

}
struct CreateUserPlanRequest: Codable {
    let appTransactionId: String
    let transactionId: String
    let transactionReason: String
    let purchaseDate: Int
    let expiresDate: Int
    let originalPurchaseDate: Int
    let originalTransactionId: String
    let productId: String
    let bundleId: String
    let platformType: String
    let quantity: Int
    let type: String
    let currency: String
    let price: Double
    let subscriptionId: String
}
