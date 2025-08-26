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

}
