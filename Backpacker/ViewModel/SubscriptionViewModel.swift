//
//  SubscriptionViewModel.swift
//  Backpacker
//
//  Created by Mobile on 06/10/25.
//

import Foundation
import Alamofire

class SubscriptionViewModel {
    
    
    func getlistOfSubscriptions<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.GET_LISTOF_SUBSCRIPTIONS
   
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }

}
