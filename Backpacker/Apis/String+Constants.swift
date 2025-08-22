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
        static let screen5Title = "Add New Accommodation"
        static let screen6Title = "Add New Hangout Place"
        static let screen7Title = "Control Your Profile and Subscription"
        
    static let screen1SubTitle = "Effortlessly manage your job postings and connect with verified bag packers anytime, anywhere."
    static let screen2SubTitle = "Create job listings, set dates, assign tasks, and update job posts—everything from a single dashboard"
    static let screen3SubTitle = "View available bag packers, assign jobs and track their live locations on the map."
    static let screen4SubTitle = "Use the calendar to track job shifts and view each casual's job history in one place."
        static let screen5SubTitle = "List your place and welcome backpackers from around the world."
        static let screen6SubTitle = "Host a cool spot where travelers meet, chill, and connect."
        static let screen7SubTitle = "Update your profile, choose from flexible plans, manage your account, or contact support anytime"
        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
        static let screen5Image = "walkthrough_5"
        static let screen6Image = "walkthrough_6"
        static let screen7Image = "walkthrough_5"
        #else
        static let screen1Title = "Welcome to\nBackpackers"
        static let screen2Title = "Discover What's\nAround You"
        static let screen3Title = "Find\nAccommodations"
        static let screen4Title = "Discover Cool\nPlaces"
        static let screen5Title = "Find Work on\nthe Go"
        static let screen6Title = "Connect with\nEmployers"
        
    static let screen1SubTitle = "Start your journey with the ultimate travel and work app made forbackpackers."
    static let screen2SubTitle = "Enable location to find jobs, accommodations, and hotspots near you."
    static let screen3SubTitle = "Search hostels, rooms, and more."
    static let screen4SubTitle = "Check out trending places, events, and experiences near your location"
        static let screen5SubTitle = "Browse flexible and verified job opportunities during your trip."
        static let screen6SubTitle = "Work with trusted businesses that welcome backpackers."
        // Image names (as in Assets.xcassets)
        static let screen1Image = "walkthrough_1"
        static let screen2Image = "walkthrough_2"
        static let screen3Image = "walkthrough_3"
        static let screen4Image = "walkthrough_4"
        static let screen5Image = "walkthrough_5"
        static let screen6Image = "walkthrough_6"
#endif
           
        }
}

