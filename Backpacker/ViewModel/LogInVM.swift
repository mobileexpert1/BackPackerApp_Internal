//
//  LogInVM.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import Foundation
import Foundation

class LogInVM {
    
    func loginUser(
        loginRequest: LoginRequest,
        completion: @escaping (_ success: Bool, _ result: LoginResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.loginUser(params: loginRequest.asDictionary) { (success, result: LoginResponse?, statusCode: Int?) in
            completion(true, result, statusCode)
        }
    }

    func SendOtp(
        otpRequest: OtpRequest,
        completion: @escaping (_ success: Bool, _ result: OtpResponse?, _ statusCode: Int?) -> Void
    ) {
        UserStore.shared.sendOTP(params: otpRequest.asDictionary) { (success, result: OtpResponse?, statusCode: Int?) in
            if success {
                print("✅ Response Otp:", result as Any)
                if let val = result {
                    UserDefaultsManager.shared.bearerToken = val.data?.accessToken
                    UserDefaultsManager.shared.refreshToken = val.data?.refreshToken
                }
                completion(true, result, statusCode)
            } else {
                print("❌ Otp failed")
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
                print("✅ Response Otp:", result as Any)
                completion(true, result, statusCode)
            } else {
                print("❌ Otp failed")
                completion(true, result, statusCode)
            }
        }
    }

    
    func refreshToken(completion: @escaping (_ success: Bool, _ result: OtpResponse?, _ statusCode: Int?) -> Void) {
        UserStore.shared.refreshToken { (success, result: OtpResponse?, statusCode: Int?) in
            if success {
                print("🔄 Refresh token success:", result as Any)
                completion(true, result, statusCode)
            } else {
                print("❌ Refresh token failed")
                completion(true, result, statusCode)
            }
        }
    }


  

}
