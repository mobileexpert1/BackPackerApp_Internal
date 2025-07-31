//
//  Constants.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import Foundation

import Foundation

struct ApiConstants {
    struct API {
        static let DEBUG_MODE_ON = true
        private static let BASE_URL : String = {
            if DEBUG_MODE_ON {
                return "http://192.168.11.4:3001/"
            }
            else {
                return "http://192.168.11.4:3001/"
            }
        }()
        
        private static let API_URL = BASE_URL + "/customer"
        private static let VERSION = API_URL  + ""
        static let LOGIN_USER = BASE_URL + "api/auth/login"
        static let OTP_SEND = BASE_URL + "api/auth/verifyOtp"
        static let OTP_RESEND = BASE_URL + "api/auth/resendOtp"
        static let REFRESH_TOKEN = BASE_URL + "api/auth/refreshToken"
        static let ADD_HANGOUT = BASE_URL + "api/employer/hangout"
        static let ADD_ACCOMMODATION = BASE_URL + "api/employer/accommodation"
        
    }
    struct Alert {
        static let invalidPhoneTitle = "Invalid Phone Number"
        static let invalidPhoneMessage = "Please enter a valid phone number based on your selected country."
        static let okButton = "OK"
    }
    
    struct General {
        static let appName = "BackPacker"
        static let somethingWentWrong = "Something went wrong. Please try again."
    }
    
    struct Placeholder {
        static let phoneNumber = "Enter your phone number"
    }
    
    struct Keys {
        static let userToken = "user_token"
        static let isLoggedIn = "is_logged_in"
    }
    struct Walkthrough {
        // Titles
        static let screen1Title = "Backpackers can search for jobs based on their current location."
        static let screen2Title = "Enable location access to receive the most relevant job opportunities near you."
        static let screen3Title = "Backpackers can easily accept or reject job offers based on their preferences."
        static let screen4Title = "Set your availability to receive job offers that match your preferred working schedule."
        
        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
    }
}
