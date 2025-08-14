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
                return "http://192.168.11.4:3000/"
            }
            else {
                return "http://192.168.11.4:3000/"
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
        static func getBackpackersProfileURL(page: Int, perPage: Int,search: String? = nil, type: Int, appType : String) -> String {
            var url = "\(BASE_URL)api/employer/backpackersProfile?page=\(page)&perPage=\(perPage)&type=\(type)&appType=\(appType)"
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        static let ADD_NEWJOB = BASE_URL + "api/employer/job"
        static let SWITCH_ROLE = BASE_URL + "api/employer/roleSwitch"
        static let BACKPACKER_HOME = BASE_URL + "api/backpackers/home"
        static let BACKPACKER_Profile = BASE_URL + "api/backpackers/profile"
        static let BACKPACKER_JOBSSEEALL = BASE_URL + "api/backpackers/jobs"
        
        static func getBACKPACKER_JOBSSEEALLURL(page: Int, perPage: Int, search: String? = nil) -> String {
            var url = "\(BASE_URL)api/backpackers/jobs?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        static func getBACKPACKER_JOBSSEEALLURLWITHTYPE(page: Int, perPage: Int, search: String? = nil, type: Int) -> String {
            var url = "\(BASE_URL)api/backpackers/jobs/seeAll?page=\(page)&perPage=\(perPage)&type=\(type)"
            
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        static func getBACKPACKER_ACCOMMODATION_URL(
            page: Int,
            perPage: Int,
            lat: Double,
            long: Double,
            radius: Int? = nil,
            sortByPrice: String? = nil,
            facilities: String? = nil,
            search: String? = nil
        ) -> String {
            var url = "\(BASE_URL)api/backpackers/accommodation?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            
            if let sort = sortByPrice?.trimmingCharacters(in: .whitespacesAndNewlines), !sort.isEmpty {
                url += "&sortByPrice=\(sort)"
            }
            
            if let facilities = facilities?.trimmingCharacters(in: .whitespacesAndNewlines), !facilities.isEmpty {
                let encodedFacilities = facilities.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&facilities=\(encodedFacilities)"
            }
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func getBACKPACKER_HANGOUT_URL(
            page: Int,
            perPage: Int,
            lat: Double,
            long: Double,
            radius: Int? = nil,
            search: String? = nil
        ) -> String {
            var url = "\(BASE_URL)api/backpackers/hangout?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        static func getBACKPACKER_JOBDETAIL(jobID:String?) -> String {
            var url = "\(BASE_URL)api/backpackers/jobs/"
            if let jobID = jobID {
                url += "\(jobID)"
            }
            return url
        }
        static func getBACKPACKER_HANGOUTDETAIL(hangoutID:String?) -> String {
            var url = "\(BASE_URL)api/backpackers/hangout/"
            if let hangoutID = hangoutID {
                url += "\(hangoutID)"
            }
            return url
        }
        static func getBACKPACKER_AccomodationDETAIL(accommodationID:String?) -> String {
            var url = "\(BASE_URL)api/backpackers/accommodation/"
            if let accommodationID = accommodationID {
                url += "\(accommodationID)"
            }
            return url
        }
        
        
        //MARK: - Employer
        
        
        static let EMPLOYER_HOME = BASE_URL + "api/employer/home/employer"
        static let EMPLOYER_ACCOMODATION_HOME = BASE_URL + "api/employer/home/accommodation"
        static let EMPLOYER_HANGOUT_HOME = BASE_URL + "api/employer/home/hangout"
        static let EMPLOYER_JOB_TODAY = BASE_URL + "api/employer/job"
        static func getEMPLOYER_JOBSSEEALLURLWITHTYPE(page: Int, perPage: Int, search: String? = nil, type: Int) -> String {
            var url = "\(BASE_URL)api/employer/job/seeAll?page=\(page)&perPage=\(perPage)&type=\(type)"
            
            if let searchText = search?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let encodedSearch = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
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
