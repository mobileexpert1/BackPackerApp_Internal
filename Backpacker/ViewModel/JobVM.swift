//
//  JobVM.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import Foundation
import Alamofire

class JobVM {
    
    func getBackpackersList<T: Codable>(
        page: Int,
        perPage: Int,
        search: String,
        type: Int,
        isComeFromEmployer : Bool = false, // Manily for Backpacker app
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        var appType = String()
        var typeOf = Int()
#if Backapacker
        //Type 1 for backpacke
        //Type 2 for emplloyerr
        appType = "backpacker"
        if isComeFromEmployer == true{
            typeOf = 2
        }else{
            typeOf = 1
        }
        #else
        appType = "employer"
        typeOf = 1
#endif
        let url = ApiConstants.API.getBackpackersProfileURL(page: page, perPage: perPage,search: search,type: typeOf,appType: appType)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    func uploadNewJob(
        name: String,
        address: String,
        lat: Double,
        long: Double,
        locationText: String,
        description: String,
        requirement: String,
        price: String,
        startDate: String,
        endDate: String,
        startTime: String,
        endTime: String,
        selectedBackpackerJSONString: String,
        image: Data?,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
        guard let token = UserDefaultsManager.shared.bearerToken, !token.isEmpty else {
            completion(false, "Authorization token is missing.", nil)
            return
        }

        let url = ApiConstants.API.ADD_NEWJOB

        let params: Parameters = [
            "name": name,
            "address": address,
            "lat": lat,
            "long": long,
            "locationText": locationText,
            "description": description,
            "requirements": requirement,
            "price": price,
            "startDate": startDate,
            "endDate": endDate,
            "startTime": startTime,
            "endTime": endTime,
            "requests": selectedBackpackerJSONString
        ]

        let headers = ServiceManager.sharedInstance.getHeaders()

        ServiceManager.sharedInstance.requestMultipartAPI(
            url,
            image: image,
            method: .post,
            parameters: params,
            headers: headers
        ) { (result: ApiResult<ApiResponseModel<HangoutResponseData>, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("Upload success")
                completion(true, data?.message ?? "Job added successfully", statusCode)

            case .failure(let error, let statusCode):
                print("Upload failed:", error.localizedDescription)
                completion(false, error.localizedDescription, statusCode)
            }
        }
    }
    func getJobListSeeAll<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_JOBSSEEALLURL(page: page, perPage: perPage, search: search)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    func getJobListSeeAllWithType<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        type:Int,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_JOBSSEEALLURLWITHTYPE(page: page, perPage: perPage,search: search, type: type)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    // MARK: - BackPacker: JobDetail
    func getBackPackerJobDetail<T: Codable>(
        jobID:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_JOBDETAIL(jobID: jobID)

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

