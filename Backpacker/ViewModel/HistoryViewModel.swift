//
//  HistoryViewModel.swift
//  Backpacker
//
//  Created by Mobile on 10/09/25.
//

import Foundation
class HistoryViewModel {
    
    
    func getEmpBackpackersList<T: Codable>(
        page: Int,
        perPage: Int,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_EmployerLIst(page: page, perPage: perPage)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func getEmpCompletedJobs<T: Codable>(
        page: Int,
        perPage: Int,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getEMPLOYER_COMPLETEDJOBS(page: page, perPage: perPage)

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
