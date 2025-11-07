//
//  ProfileVM.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import Foundation
import UIKit
import Alamofire

class ProfileVM {
    
    func getBackPackerProfile<T: Codable>(
        isComeFromUpdate:Bool = false,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil,nil)
      return
  }
      
        let url = ApiConstants.API.BACKPACKER_Profile

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func updateBackPackerProfile<T: Codable>(
        isComeFromUpdate: Bool = false,
        email: String,
        name: String,
        state: String,
        area: String,
        visaType: String,
        notificationStatus: Bool,
        startDate: String,
        endDate:String,
        dob : String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil,nil)
      return
  }

        let url = ApiConstants.API.BACKPACKER_Profile

        let parameters: Parameters = [
            "email": email,
            "name": name,
            "state": state,
            "area": area,
            "visaType": visaType,
            "notificationStatus": notificationStatus ? "1" : "0",
            "startDate": startDate,
            "endDate": endDate,
            "dob": dob
        ]
 let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestApi(
            url,
            method: .put,
            parameters: parameters,
            headers: headers
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
        
    }

    func getContent<T: Codable>(
        key:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil,nil)
      return
  }
      
        let url = ApiConstants.API.GET_CONTENT(for: key)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    
    func getCompanyDetail<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil,nil)
      return
  }
      
        let url = ApiConstants.API.COMPANY_DETAIL

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    //MARK: Add New Accommodation
        func addCompanyDetail(
            name: String,
            industryTypeId: String,
            logo: Data?,
            website: String,
            contactNumber: String,
            email:String,
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

            let url = ApiConstants.API.CREATE_NEW_COMPANY // 🔁 Replace with correct endpoint

            var params: Parameters = [
                        "name": name,
                        "industryTypeId": industryTypeId,
                        "logo": logo,
                        "website": website,
                        "contactNumber": contactNumber,
                        "email": email
                    ]
            
          
            let headers = ServiceManager.sharedInstance.getHeaders()
            ServiceManager.sharedInstance.requestMultipartAPI(
                url,
                image: logo,
                method: .post,
                parameters: params,
                headers: headers,
                isComeFromCompany: true
            ) { (result: ApiResult<ApiResponseModel<UpdatedCompanyDetail>, APIError>) in
                switch result {
                case .success(let data, let statusCode):
                    print("Company uploaded successfully.")
                    completion(true, data?.message ?? "Company Added", statusCode)

                case .failure(let error, let statusCode):
                    print("Company upload failed:", error.localizedDescription)
                    completion(false, error.localizedDescription, statusCode)
                }
            }
            
            
        }
    
    // MARK: -Update Company Deail
    func updateComapnyDetail(
        comapnyId: String,
        name: String,
        industryTypeId: String,
        logo: Data?,
        website: String,
        contactNumber: String,
        completion: @escaping (Bool, String?, Int?) -> Void
    )  {
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

        let url = ApiConstants.API.CREATE_NEW_COMPANY // 🔁 Replace with correct endpoint

        var params: Parameters = [
            "id":comapnyId,
                    "name": name,
                    "industryTypeId": industryTypeId,
                    "logo": logo,
                    "website": website,
                    "contactNumber": contactNumber
                ]
        
      
        let headers = ServiceManager.sharedInstance.getHeaders()
        ServiceManager.sharedInstance.requestMultipartAPI(
            url,
            image: logo,
            method: .patch,
            parameters: params,
            headers: headers,
            isComeFromCompany: true
        ) { (result: ApiResult<ApiResponseModel<UpdatedCompanyDetail>, APIError>) in
            switch result {
            case .success(let data, let statusCode):
                print("Company uploaded successfully.")
                completion(true, data?.message ?? "Company Added", statusCode)

            case .failure(let error, let statusCode):
                print("Company upload failed:", error.localizedDescription)
                completion(false, error.localizedDescription, statusCode)
            }
        }
        
        
    }
    //MARK: Add New Accommodation
        func addCompanyLocation(
            name: String,
            lat: Double,
            long: Double,
            businessCompanyId: String,
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

            let url = ApiConstants.API.COMPANY_LOCATION // 🔁 Replace with correct endpoint

            
            let req = CompanyLocationRequest(name: name, lat: lat, long: long, businessCompanyId: businessCompanyId)

            
            // Encode the request
            let jsonBody: String
            do {
                let data = try JSONEncoder().encode(req)
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
               ) { (result: ApiResult<ApiResponseModel<CompanyLocationDetail>, APIError>) in
                   switch result {
                   case .success(let response, let statusCode):
                       completion(response?.success ?? true, response?.message ?? "Something went wrong", statusCode)
                   case .failure(let error, let statusCode):
                       completion(false, error.customDescription, statusCode)
                   }
               }
            
        }
    func addCompanyLocation2(
        name: String,
        lat: Double,
        long: Double,
        businessCompanyId:String,
        completion: @escaping (ApiResponseModel<LocationCheckData>?, APIError?, Int?) -> Void
    ) {
        #if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
        #else
        let bearerToken = UserDefaultsManager.shared.bearerToken
        #endif

        guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
            print("⚠️ No refresh token found.")
            completion(nil, .customError(message: "Refresh token not found"), nil)
            return
        }

        let url = ApiConstants.API.COMPANY_LOCATION

        let req = CompanyLocationRequest(name: name, lat: lat, long: long, businessCompanyId: businessCompanyId)

        // Encode the request
        let jsonBody: String
        do {
            let data = try JSONEncoder().encode(req)
            jsonBody = String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            print("⚠️ Failed to encode request: \(error)")
            completion(nil, .customError(message: "Failed to encode request: \(error)"), nil) // ✅ FIXED
            return
        }

        print("Request JSON:", jsonBody)

        ServiceManager.sharedInstance.requestValidatedApiCreateAvailabilty(
            url,
            method: .post,
            parameters: nil,
            httpBody: jsonBody,
            headers: ServiceManager.sharedInstance.getHeaders()
        ) { (result: ApiResult<ApiResponseModel<LocationCheckData>, APIError>) in
            switch result {
            case .success(let response, let statusCode):
                completion(response, nil, statusCode)
            case .failure(let error, let statusCode):
                completion(nil, error, statusCode)
            }
        }
    }


    func getIndustriesList<T: Codable>(
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
#if BackpackerHire
        let bearerToken = UserDefaultsManager.shared.employerbearerToken
  #else
  let bearerToken = UserDefaultsManager.shared.bearerToken
  #endif
  
  guard let bearerToken = bearerToken, !bearerToken.isEmpty else {
      print("⚠️ No refresh token found.")
      completion(false, nil,nil)
      return
  }
      
        let url = ApiConstants.API.INDUSTRIES_LIST

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func getCompanyLocationList<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        businessCompanyId : String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getCOMPANY_LOCATION_URL(page: page, perPage: perPage, search: search, businessCompanyId: businessCompanyId)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    func getAddJobCompanyLocationList<T: Codable>(
        page: Int,
        perPage: Int,
        search:String,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getAddJobCOMPANY_LOCATION_URL(page: page, perPage: perPage, search: search)

        ServiceManager.sharedInstance.requestApi(
            url,
            method: .get,
            parameters: nil,
            httpBody: nil
        ) { (success: Bool, result: T?, statusCode: Int?) in
            completion(success, result, statusCode)
        }
    }
    //MARK: Delet
     func delete<T: Codable>(
         locationID:String,
         completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
     ) {
         let url = ApiConstants.API.DELETE_ComapnyLOCATION(locID: locationID)

         ServiceManager.sharedInstance.requestApi(
             url,
             method: .delete,
             parameters: nil,
             httpBody: nil
         ) { (success: Bool, result: T?, statusCode: Int?) in
             completion(success, result, statusCode)
         }
     }
    // MARK: - BackPacker: List of All Accommodation
    func GETComapnyList<T: Codable>(
        page: Int,
        perPage: Int,
        search: String? = nil,
        completion: @escaping (_ success: Bool, _ result: T?, _ statusCode: Int?) -> Void
    ) {
        let url = ApiConstants.API.getEMPLOYER_COMPANY_LISt(
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
}
struct CompanyLocationRequest: Codable {
    let name: String
    let lat: Double
    let long : Double
    let businessCompanyId : String
}

