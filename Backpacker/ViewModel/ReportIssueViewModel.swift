//
//  ReportIssueViewModel.swift
//  Backpacker
//
//  Created by Mobile on 16/09/25.
//

import Foundation
import Alamofire

class ReportIssueViewModel {
    
    func createSupportTicket(
        request: ReportRequest,
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

        let url = ApiConstants.API.CREATE_NEW_TICKET

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
           ) { (result: ApiResult<ApiResponseModel<TicketData>, APIError>) in
               switch result {
               case .success(let response, let statusCode):
                   completion(response?.success ?? true, response?.message ?? "Something went wrong", statusCode)
               case .failure(let error, let statusCode):
                   completion(false, error.customDescription, statusCode)
               }
           }
        
        // Now pass `jsonBody` as the HTTP body to your request API
    }
    func getTicketList<T: Codable>(
        page: Int,
        perPage: Int,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getTICKET_LIST_URL(
            page: page,
            perPage: perPage
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
    
    
    func getAdminChatt<T: Codable>(
        page: Int,
        perPage: Int,
        ticketId: String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getTICKET_CHAT_URL(
            page: page,
            perPage: perPage,
            ticketId: ticketId
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
    
    func sendAdminChat(
        request: AdminChatRequest,
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

        let url = ApiConstants.API.SEND_ADMIN_CHAT

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




struct ReportRequest: Codable {
    let title: String
    let desc: String
    let reason : String
}
