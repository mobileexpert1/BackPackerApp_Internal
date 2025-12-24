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
        locationId: String,
        jobFilter:String,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
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
            "requests": selectedBackpackerJSONString,
            "locationId":locationId,
            "jobFilter":jobFilter
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
    
    // MARK: - Accept reject job: JobDetail
    func acceptRejectJob<T: Codable>(
        jobID: String,
        status: String, // <-- add this parameter so you can pass "rejected" or "accepted"
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.ACCEPT_REJECTJOB(jobId: jobID)

        // Create the body
        let body: Parameters = [
            "status": status
        ]

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .patch,
            parameters: nil,   // keep this nil, since we're sending body separately
            httpBody: body.toJsonString()
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }

    
    
    
    //MARK: - Employer Job list
    
    func getEmployerJobListSeeAll<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.EMPLOYER_JOB_TODAY

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func getEmpJobListSeeAllWithType<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        type:Int,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getEMPLOYER_JOBSSEEALLURLWITHTYPE(page: page, perPage: perPage,search: search, type: type)

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
    func getEmployerJobDetail<T: Codable>(
        jobID:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getEMPLOYER_JOBDETAIL(jobID: jobID)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    //MARK: - DeletJob
    
    func deleteJob<T: Codable>(
        jobID:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.DELETE_JOB(jobID: jobID)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .delete,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    //MARK: - Edit job empoyer
    
    func editJob(
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
        jobID: String,
        locationId:String,
        jobFilter:String,
        completion: @escaping (Bool, String?, Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, "Authorization token is missing.", nil)
      return
  }
       
        let url = ApiConstants.API.EDITJOB(jobId:jobID )

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
            "requests": selectedBackpackerJSONString,
            "locationId":locationId,
            "jobFilter":jobFilter
        ]

        let headers = ServiceManager.sharedInstance.getHeaders()

        ServiceManager.sharedInstance.requestMultipartAPI(
            url,
            image: image,
            method: .put,
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
    
    //MARK: - FAVOURATE


    func MakeJOBFAVOURATE(
        id: String,
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

        let url = ApiConstants.API.FAVOURATE_JOBS

        //  Create request body
        let request = FavouriteJobRequest(jobId: id)

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
        // Example output: {"jobId":"60c72b2f5f1b2c001c8d4567"}

        //  Call your generic request
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
    func MakeAccomodationFAVOURATE(
        id: String,
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

        let url = ApiConstants.API.FAVOURATE_ACCOMODATION

        //  Create request body
        let request = FavouriteAccomodationRequest(accommodationId: id)

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
        // Example output: {"jobId":"60c72b2f5f1b2c001c8d4567"}

        //  Call your generic request
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
    
    func MakeHangoutFAVOURATE(
        id: String,
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

        let url = ApiConstants.API.FAVOURATE_HANGOUT

        //  Create request body
        let request = FavouriteHangoutbRequest(hangoutId: id)

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
        // Example output: {"jobId":"60c72b2f5f1b2c001c8d4567"}

        //  Call your generic request
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
    
    
    //MARK: - BP HIstory job list
    
    
    func getCompletedJob<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getBACKPACKER_JOBHISTORYURL(page: page, perPage: perPage, search: search)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    //MARK: - Get Current Plan User
    
    
    func getCurrentPlan<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.CURRENT_PLAN

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

