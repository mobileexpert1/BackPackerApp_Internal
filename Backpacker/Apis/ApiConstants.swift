//
//  Constants.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation

struct ApiConstants {
    struct API { 
        static let DEBUG_MODE_ON = true
        private static let BASE_URL: String = {
            if DEBUG_MODE_ON {
                return "https://backpacker.csdevhub.com/"//"https://backpacker.csdevhub.com/"//"http://http://192.168.11.4:3003/"
            } else {
                return "https://backpacker.csdevhub.com/"//"https://backpacker.csdevhub.com/"//"http://192.168.11.4:3003/"
            }
        }()
        
        static let API_IMAGEURL = BASE_URL + "assets/"
        static let LOGIN_USER = BASE_URL + "api/auth/login"
        static let OTP_SEND = BASE_URL + "api/auth/verifyOtp"
        static let OTP_RESEND = BASE_URL + "api/auth/resendOtp"
        static let REFRESH_TOKEN = BASE_URL + "api/auth/refreshToken"
        static let ADD_HANGOUT = BASE_URL + "api/employer/hangout"
        static let ADD_ACCOMMODATION = BASE_URL + "api/employer/accommodation"
        static func getBackpackersProfileURL(
            page: Int, perPage: Int, search: String? = nil, type: Int,
            appType: String
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/backpackersProfile?page=\(page)&perPage=\(perPage)&type=\(type)&appType=\(appType)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        static let ADD_NEWJOB = BASE_URL + "api/employer/job"
        static let SWITCH_ROLE = BASE_URL + "api/employer/roleSwitch"
        static let BACKPACKER_HOME = BASE_URL + "api/backpackers/home"
        static let BACKPACKER_Profile = BASE_URL + "api/backpackers/profile"
        static let BACKPACKER_JOBSSEEALL = BASE_URL + "api/backpackers/jobs"
        static func getBACKPACKER_JOBSSEEALLURL(
            page: Int, perPage: Int, search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/backpackers/jobs?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        static func getBACKPACKER_JOBSSEEALLURLWITHTYPE(
            page: Int, perPage: Int, search: String? = nil, type: Int
        ) -> String {
            var url =
            "\(BASE_URL)api/backpackers/jobs/seeAll?page=\(page)&perPage=\(perPage)&type=\(type)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
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
            var url =
            "\(BASE_URL)api/backpackers/accommodation?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            
            if let sort = sortByPrice?.trimmingCharacters(
                in: .whitespacesAndNewlines), !sort.isEmpty
            {
                url += "&sortByPrice=\(sort)"
            }
            
            if let facilities = facilities?.trimmingCharacters(
                in: .whitespacesAndNewlines), !facilities.isEmpty
            {
                let encodedFacilities =
                facilities.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&facilities=\(encodedFacilities)"
            }
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
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
            var url =
            "\(BASE_URL)api/backpackers/hangout?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        static func getBACKPACKER_JOBDETAIL(jobID: String?) -> String {
            var url = "\(BASE_URL)api/backpackers/jobs/"
            if let jobID = jobID {
                url += "\(jobID)"
            }
            return url
        }
        static func getBACKPACKER_HANGOUTDETAIL(hangoutID: String?) -> String {
            var url = "\(BASE_URL)api/backpackers/hangout/"
            if let hangoutID = hangoutID {
                url += "\(hangoutID)"
            }
            return url
        }
        static func getBACKPACKER_AccomodationDETAIL(accommodationID: String?)
        -> String
        {
            var url = "\(BASE_URL)api/backpackers/accommodation/"
            if let accommodationID = accommodationID {
                url += "\(accommodationID)"
            }
            return url
        }
        
        static func ACCEPT_REJECTJOB(jobId: String?) -> String {
            var url = "\(BASE_URL)api/backpackers/jobs/"
            if let jobIds = jobId {
                url += "\(jobIds)"
            }
            return url
        }
        //MARK: - Employer
        
        static let EMPLOYER_HOME = BASE_URL + "api/employer/home/employer"
        static let EMPLOYER_ACCOMODATION_HOME =
        BASE_URL + "api/employer/home/accommodation"
        static let EMPLOYER_HANGOUT_HOME =
        BASE_URL + "api/employer/home/hangout"
        static let EMPLOYER_JOB_TODAY = BASE_URL + "api/employer/job"
        static func getEMPLOYER_JOBSSEEALLURLWITHTYPE(
            page: Int, perPage: Int, search: String? = nil, type: Int
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/job/seeAll?page=\(page)&perPage=\(perPage)&type=\(type)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        
        static func getEMPLOYER_JOBDETAIL(jobID: String?) -> String {
            var url = "\(BASE_URL)api/employer/job/"
            if let jobID = jobID {
                url += "\(jobID)"
            }
            return url
        }
        
        static func getEMPLOYER_ACCOMMODATION_URL(
            page: Int,
            perPage: Int,
            lat: Double,
            long: Double,
            radius: Int? = nil,
            sortByPrice: String? = nil,
            facilities: String? = nil,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/accommodation?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            
            if let sort = sortByPrice?.trimmingCharacters(
                in: .whitespacesAndNewlines), !sort.isEmpty
            {
                url += "&sortByPrice=\(sort)"
            }
            
            if let facilities = facilities?.trimmingCharacters(
                in: .whitespacesAndNewlines), !facilities.isEmpty
            {
                let encodedFacilities =
                facilities.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&facilities=\(encodedFacilities)"
            }
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func getAccomodation_AccomodationDETAIL(accommodationID: String?)
        -> String
        {
            var url = "\(BASE_URL)api/employer/accommodation/"
            if let accommodationID = accommodationID {
                url += "\(accommodationID)"
            }
            return url
        }
        
        static func getEmployer_HANGOUT_URL(
            page: Int,
            perPage: Int,
            lat: Double,
            long: Double,
            radius: Int? = nil,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/hangout?page=\(page)&perPage=\(perPage)&lat=\(lat)&long=\(long)"
            if let radius = radius {
                url += "&radius=\(radius)"
            }
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        static func getEMPLOYER_HANGOUTDETAIL(hangoutID: String?) -> String {
            var url = "\(BASE_URL)api/employer/hangout/"
            if let hangoutID = hangoutID {
                url += "\(hangoutID)"
            }
            return url
        }
        
        static func EDITACCOMMODATION(accomodation: String?) -> String {
            var url = "\(BASE_URL)api/employer/accommodation/"
            if let hangoutID = accomodation {
                url += "\(hangoutID)"
            }
            return url
        }
        
        static func EDITHANGOUT(hangout: String?) -> String {
            var url = "\(BASE_URL)api/employer/hangout/"
            if let hangoutID = hangout {
                url += "\(hangoutID)"
            }
            return url
        }
        static func EDITJOB(jobId: String?) -> String {
            var url = "\(BASE_URL)api/employer/job/"
            if let jobId = jobId {
                url += "\(jobId)"
            }
            return url
        }
        static func DELETE_JOB(jobID: String?) -> String {
            var url = "\(BASE_URL)api/employer/job/"
            if let jobID = jobID {
                url += "\(jobID)"
            }
            return url
        }
        static func DELETE_ACCOMMODATION(accID: String?) -> String {
            var url = "\(BASE_URL)api/employer/accommodation/"
            if let accID = accID {
                url += "\(accID)"
            }
            return url
        }
        static func DELETE_HANGOUT(hangID: String?) -> String {  //api/employer/accommodation
            var url = "\(BASE_URL)api/employer/hangout/"
            if let hangID = hangID {
                url += "\(hangID)"
            }
            return url
        }
        
        static func NOTIFICATION_LIST(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/backpackers/notifications?page=\(page)&perPage=\(perPage)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func EMPLPYER_NOTIFICATION_LIST(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/notifications?page=\(page)&perPage=\(perPage)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        static func NACKPACKER_NOTIFICATION_READ(ID: String?) -> String {
            var url = "\(BASE_URL)api/backpackers/notifications"
            
            return url
        }
        static func EMPLOYER_NOTIFICATION_READ(ID: String?) -> String {
            var url = "\(BASE_URL)api/employer/notifications"
            
            return url
        }
        
        static let CREATE_AVAILABILITY_FOR_BACKAPACKER = BASE_URL + "api/backpackers/availability"
        static let GET_BACKAPACKER_AVAILABILITY = BASE_URL + "api/backpackers/availability"
        
        //MARK: - Favouare
        static let FAVOURATE_JOBS  = BASE_URL + "api/favorite/job"
        static let FAVOURATE_ACCOMODATION  = BASE_URL + "api/favorite/accommodation"
        static let FAVOURATE_HANGOUT  = BASE_URL + "api/favorite/hangout"
        
        static func getFAVOURATE_ACCOMODATION_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/favorite/accommodation?page=\(page)&perPage=\(perPage)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func getFAVOURATE_HANGOUT_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/favorite/hangout?page=\(page)&perPage=\(perPage)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func getFAVOURATE_JOBS_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/favorite/job?page=\(page)&perPage=\(perPage)"
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static  let UPDATE_OVERALL_AVAILABILITY =  "\(BASE_URL)api/backpackers/availability"
        
        
        static func getBACKPACKER_JOBHISTORYURL(
            page: Int, perPage: Int, search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/backpackers/jobs/history?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        
        
        //MARK: - Emplyer calendar avaibilty
        
        
        static func getBACKPACKER_EmployerCalendar(
            page: Int,
            perPage: Int,
            dateStr: String? = nil
        ) -> String {
            var url = "\(BASE_URL)api/employer/calendar?page=\(page)&perPage=\(perPage)"
            
            if let dateStr = dateStr, !dateStr.isEmpty {
                url += "&dateStr=\(dateStr)"
            }
            
            return url
        }
        static let LOCATION_UPDATE = BASE_URL + "api/location"
        static func GET_CONTENT(for key: String) -> String {
            // Make sure the key is URL-safe
            guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return "\(BASE_URL)api/common/content/\(key)"
            }
            return "\(BASE_URL)api/common/content/\(encodedKey)"
        }
        
        
        static func getBACKPACKER_EmployerLIst(
            page: Int,
            perPage: Int
        ) -> String {
            let url = "\(BASE_URL)api/employer/history/backpackers?page=\(page)&perPage=\(perPage)"
            return url
        }
        
        
        static func getEMPLOYER_COMPLETEDJOBS(
            page: Int,
            perPage: Int
        ) -> String {
            let url = "\(BASE_URL)api/employer/history/jobs?page=\(page)&perPage=\(perPage)"
            return url
        }
        
        //MARK: - Chat
        //
        static func getEMPLOYER_CHAT_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/chat/employerList?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        
        static func getBackpackerR_CHAT_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/chat/backpackerList?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        
        static func getCHAT_LIST_URL(
            page: Int,
            perPage: Int,
            otherUserId: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/chat?page=\(page)&perPage=\(perPage)"
            
            let encodedSearch =
            otherUserId?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            url += "&otherUserId=\(encodedSearch)"
            return url
        }
        static let SEND_CHAT = BASE_URL + "api/chat"
        
        
        //MARK: - Raise Ticket
        
        static let CREATE_NEW_TICKET = BASE_URL + "api/ticket"
        
        
        static func getTICKET_LIST_URL(
            page: Int,
            perPage: Int
        ) -> String {
            let url =
            "\(BASE_URL)api/ticket?page=\(page)&perPage=\(perPage)"
            return url
        }
        
        
        static func getTICKET_CHAT_URL(
            page: Int,
            perPage: Int,
            ticketId : String
        ) -> String {
            let url =
            "\(BASE_URL)api/ticket/chat?ticketId=\(ticketId)&page=\(page)&perPage=\(perPage)"
            return url
        }
        
        static let SEND_ADMIN_CHAT = BASE_URL + "api/ticket/chat"
        static let COMPANY_DETAIL = BASE_URL + "api/employer/companyDetail"
        static let COMPANY_LOCATION = BASE_URL + "api/employer/companyDetail/location"
        static let INDUSTRIES_LIST = BASE_URL + "api/industryType"
        
        static let CREATE_NEW_COMPANY = BASE_URL + "api/employer/companyDetail"
        static func getCOMPANY_LOCATION_URL(
            page: Int,
            perPage: Int,
            search: String? = nil,
            businessCompanyId : String
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/companyDetail/location?page=\(page)&perPage=\(perPage)&businessCompanyId=\(businessCompanyId)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        
        static func getAddJobCOMPANY_LOCATION_URL(
            page: Int,
            perPage: Int,
            search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/companyDetail/locations?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            return url
        }
        static func DELETE_ComapnyLOCATION(locID: String?) -> String {  //api/employer/accommodation
            var url = "\(BASE_URL)api/employer/companyDetail/location/"
            if let locID = locID {
                url += "\(locID)"
            }
            return url
        }
        static func getEMPLOYER_COMPANY_LISt(
            page: Int, perPage: Int, search: String? = nil
        ) -> String {
            var url =
            "\(BASE_URL)api/employer/companyDetail?page=\(page)&perPage=\(perPage)"
            
            if let searchText = search?.trimmingCharacters(
                in: .whitespacesAndNewlines), !searchText.isEmpty
            {
                let encodedSearch =
                searchText.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed) ?? ""
                url += "&search=\(encodedSearch)"
            }
            
            return url
        }
        
        //MARK: - Delete Profile
        static let DELETE_PROFILEW = BASE_URL + "api/profile"
       //MARK: - Subscriptions
        
       // https://backpacker.csdevhub.com/api/admin/subscription
        static let GET_LISTOF_SUBSCRIPTIONS = BASE_URL + "api/subscription"
        static func GET_LISTOF_SUBSCRIPTIONSNEW(
            platform: String, country: String
        ) -> String {
            let url =
            "\(BASE_URL)api/subscription?platform=\(platform)&country=\(country)"
            
            return url
        }
        
        static let CREATE_NEW_USER_PLAN = BASE_URL + "api/backpackers/userPlan"
        
        
        //MARK:  -  PRivay URLS
        static let PRIVACY_URL = BASE_URL + "privacy-policy/backpacker"
        }
 
    
 
    
    
    
    struct Alert {
        static let invalidPhoneTitle = "Invalid Phone Number"
        static let invalidPhoneMessage =
            "Please enter a valid phone number based on your selected country."
        static let okButton = "OK"
    }

    struct General {
        static let appName = "BackPacker"
        static let somethingWentWrong =
            "Something went wrong. Please try again."
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
        static let screen1Title =
            "Backpackers can search for jobs based on their current location."
        static let screen2Title =
            "Enable location access to receive the most relevant job opportunities near you."
        static let screen3Title =
            "Backpackers can easily accept or reject job offers based on their preferences."
        static let screen4Title =
            "Set your availability to receive job offers that match your preferred working schedule."

        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
    }
}
