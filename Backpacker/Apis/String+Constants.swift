//
//  String+Constants.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
struct Constants{
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
#if BackpackerHire
        
        static let screen1Title = "Welcome to Backpacker Hire"
        static let screen2Title = "Post and Manage Jobs with Ease"
        static let screen3Title = "Track & Assign Bag Packers"
        static let screen4Title = "Keep Everything Organized"
        static let screen5Title = "Control Your Profile and Subscription"
        
    static let screen1SubTitle = "Effortlessly manage your job postings and connect with verified bag packers anytime, anywhere."
    static let screen2SubTitle = "Create job listings, set dates, assign tasks, and update job posts—everything from a single dashboard"
    static let screen3SubTitle = "View available bag packers, assign jobs and track their live locations on the map."
    static let screen4SubTitle = "Use the calendar to track job shifts and view each casual's job history in one place."
        static let screen5SubTitle = "Update your profile, choose from flexible plans, manage your account, or contact support anytime"
        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
        static let screen5Image = "walkthrough_5"
        #else
        static let screen1Title = "Search Job"
        static let screen2Title = "Enable location"
        static let screen3Title = "Accept or reject jobs"
        static let screen4Title = "Set Availability"
        
    static let screen1SubTitle = "Backpackers can search for jobs based on their current location"
    static let screen2SubTitle = "Enable location access to receive the most relevant job opportunities near you."
    static let screen3SubTitle = "Backpackers can easily accept or reject job offers based on their preferences"
    static let screen4SubTitle = "Set your availability to receive job offers that match your preferred working schedule."
        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
#endif
           
        }
}

