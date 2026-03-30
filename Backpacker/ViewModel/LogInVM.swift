//
//  LogInVM.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import Foundation
import Foundation
import Alamofire
class LogInVM {
    
    func loginUser(
        loginRequest: SignInRequest,
        completion: @escaping (_ success: Bool, _ result: LoginResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.loginUser(params: loginRequest.asDictionary) { (success, result: LoginResponse?, statusCode: Int?) in
            completion(true, result, statusCode)
        }
    }
    func SignUPUser(
        loginRequest: LoginRequest,
        completion: @escaping (_ success: Bool, _ result: LoginResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.SignUpUser(params: loginRequest.asDictionary) { (success, result: LoginResponse?, statusCode: Int?) in
            completion(true, result, statusCode)
        }
    }
    func SendOtp(
        otpRequest: OtpRequest,
        completion: @escaping (_ success: Bool, _ result: OtpResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.sendOTP(params: otpRequest.asDictionary) { (success, result: OtpResponse?, statusCode: Int?) in
            if success {
                print("-Response Otp:", result as Any)
                if let val = result {
#if BackpackerHire
                    UserDefaultsManager.shared.employerbearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.employerrefreshToken = val.data?.refreshToken
#else
                    UserDefaultsManager.shared.bearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.refreshToken = val.data?.refreshToken
#endif
                 
                }
                completion(true, result, statusCode)
            } else {
                print("- Otp failed")
                completion(true, result, statusCode)
            }
        }
    }

    func ReSendOtp(
        otpRequest: ResendOtpRequest,
        completion: @escaping (_ success: Bool, _ result: LoginResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.resendOTP(params: otpRequest.asDictionary) { (success, result: LoginResponse?, statusCode: Int?) in
            if success {
                print("-Response Otp:", result as Any)
                completion(true, result, statusCode)
            } else {
                print("- Otp failed")
                completion(true, result, statusCode)
            }
        }
    }

    
    func refreshToken(completion: @escaping (_ success: Bool, _ result: OtpResponse?, _ statusCode: Int?) -> Void) {
        UserStore.shared.refreshToken { (success, result: OtpResponse?, statusCode: Int?) in
            if success {
                print("🔄 Refresh token success:", result as Any)
                if let val = result {
#if BackpackerHire
                    UserDefaultsManager.shared.employerbearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.employerrefreshToken = val.data?.refreshToken
#else
                    UserDefaultsManager.shared.bearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.refreshToken = val.data?.refreshToken
#endif
                 
                
                }
                completion(true, result, statusCode)
            } else {
                print("- Refresh token failed")
                completion(true, result, statusCode)
            }
        }
    }

    func chooseRoleType(
        otpRequest: ChooseRoleTypeRequest,
        completion: @escaping (_ success: Bool, _ result: RoleTypeResponse?, _ statusCode: Int?) -> Void
    ){
        UserStore.shared.chooseRoleType(params: otpRequest.asDictionary) { (success, result: RoleTypeResponse?, statusCode: Int?) in
            if success {
                print("🔄 Role Type Api:", result as Any)
                
                if let val = result {
#if BackpackerHire
                    UserDefaultsManager.shared.employerbearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.employerrefreshToken = val.data?.refreshToken
#else
                    UserDefaultsManager.shared.bearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.refreshToken = val.data?.refreshToken
#endif
              
                    UserDefaults.standard.set(val.data?.subRoleType, forKey: "UserRoleType")
                    UserDefaults.standard.synchronize() // optional
                }
                
                
                completion(true, result, statusCode)
            } else {
                print("- Refresh token failed")
                completion(true, result, statusCode)
            }
        }
        
        
    }
    
    
  
    func locationUpdate(
        lat: String,
        long: String,
        completion: @escaping (Bool, String?, Int?) -> Void
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

        let url = ApiConstants.API.LOCATION_UPDATE

        let request = LocationRequest(latitude: lat, longitude: long)

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
   let headers = ServiceManager.sharedInstance.getHeaders()
        
        ServiceManager.sharedInstance.requestValidatedApiCreateAvailabilty(
            url,
            method: .put,
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
