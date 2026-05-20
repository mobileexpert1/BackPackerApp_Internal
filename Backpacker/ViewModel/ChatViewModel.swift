//  ChatViewModel.swift
//  Backpacker
//  Created by Mobile on 15/09/25.

import Foundation

class  ChatViewModel {
    
    func getEmployerChatList<T: Codable>(
        page: Int,
        perPage: Int,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getEMPLOYER_CHAT_URL(
            page: page,
            perPage: perPage,
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
    
    func getBackpackerChatList<T: Codable>(
        page: Int,
        perPage: Int,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBackpackerR_CHAT_URL(
            page: page,
            perPage: perPage,
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
    
    func getChatList<T: Codable>(
        page: Int,
        perPage: Int,
        otherUserId: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void) {
            let url = ApiConstants.API.getCHAT_LIST_URL(
                page: page,
                perPage: perPage,
                otherUserId: otherUserId
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
    
    func sendChat(
        request: ChatRequest,
        completion: @escaping (Bool, String?, Int?) -> Void) {
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
            
            let url = ApiConstants.API.SEND_CHAT
            
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
}
