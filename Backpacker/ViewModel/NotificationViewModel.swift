//
//  NotificationViewModel.swift
//  Backpacker
//
//  Created by Mobile on 26/08/25.
//

import Foundation
import Alamofire
class NotificationViewModel {
    
    
    
    // MARK: - BackPacker: List of All Accommodation
    func getBackpackerNotificationList<T: Codable>(
        page: Int,
        perPage: Int,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if Backapacker
        let url = ApiConstants.API.NOTIFICATION_LIST(page: page, perPage: perPage,search: search)
#else
        let url = ApiConstants.API.EMPLPYER_NOTIFICATION_LIST(page: page, perPage: perPage,search: search)
#endif
       

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    // MARK: - NOtificationREAD API
    func BackpackerNotificationRead<T: Codable>(
        id: String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if Backapacker
        let url = ApiConstants.API.NACKPACKER_NOTIFICATION_READ(ID: id)
#else
        let url = ApiConstants.API.NACKPACKER_NOTIFICATION_READ(ID: id)
#endif
       
        let params: Parameters = [
            "notificationId": id
        ]

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .patch,
            parameters: nil,
            httpBody: params.toJsonString()
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
}
