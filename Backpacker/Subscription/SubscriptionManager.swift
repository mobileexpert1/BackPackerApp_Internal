//
//  SubscriptionManager.swift
//  Backpacker
//
//  Created by Mobile on 07/10/25.
//

import Foundation
import StoreKit

// MARK: - Subscription Tier Enum
enum SubscriptionTier: String, CaseIterable {
    case free = "Free / Starter"
    case basic = "Basic"
    case growth = "Growth"
    case pro = "Pro"
    case headOffice = "Head Office"
}

// MARK: - Subscription Plan Model
struct SubscriptionPlan {
    let tier: SubscriptionTier
    let pricePerMonth: Double
    let description: String
    let features: [String]
    
    // App Store details
    let productID: String?
    let duration: String?   // e.g., "1 month"
    let localization: String? // Placeholder for metadata/localization
}

// MARK: - Subscription Manager
final class SubscriptionManager {
    
    static let shared = SubscriptionManager()
    
    private init() {}
    
    // MARK: - All Plans
    func getAllPlans() -> [SubscriptionPlan] {
        return [
            SubscriptionPlan(
                tier: .free,
                pricePerMonth: 0,
                description: "Low-activity venues (1 location, irregular hiring)",
                features: [
                    "1 live listing at a time (1 job, 1 accom, 1 hangout)",
                    "Verified backpacker profiles",
                    "Application inbox",
                    "Listed on Gumtree & Facebook Groups",
                    "15,000 small cafes + small accom venues"
                ],
                productID: nil,
                duration: nil,
                localization: nil
            ),
            
            SubscriptionPlan(
                tier: .basic,
                pricePerMonth: 19,
                description: "Small-to-mid venues (1 location, frequent hiring)",
                features: [
                    "Unlimited job posts - 1 location",
                    "Search Boosted (for accom or hangout)",
                    "Auto-filtering by visa/type",
                    "Employer profile upvotes",
                    "Visible on workingholidays.com (4,000 reach)"
                ],
                productID: "com.shiftly.app.subscription.basic",
                duration: "1 month",
                localization: "Missing Metadata"
            ),
            
            SubscriptionPlan(
                tier: .growth,
                pricePerMonth: 49,
                description: "Small-to-mid venues (2–3 locations, frequent hiring)",
                features: [
                    "Unlimited job posts - 3 max locations",
                    "1 push promo per month (for accom or hangout)",
                    "A.I. Recruiting Outreach",
                    "Employer profile upvotes",
                    "Backpacker Job Board ($30–70/post)"
                ],
                productID: "com.shiftly.app.subscription.growth",
                duration: "1 month",
                localization: "Missing Metadata"
            ),
            
            SubscriptionPlan(
                tier: .pro,
                pricePerMonth: 149,
                description: "(3–10 venues)",
                features: [
                    "Unlimited job posts - 10 max locations",
                    "4 push promos per month (for accom or hangout)",
                    "Job Posting Syndication - listings pushed to other platforms",
                    "Talent pool management (invite past applicants)",
                    "Sidekicker + SEEK multi-post bundles"
                ],
                productID: "com.shiftly.app.subscription.pro",
                duration: "1 month",
                localization: "Missing Metadata"
            ),
            
            SubscriptionPlan(
                tier: .headOffice,
                pricePerMonth: 299,
                description: "Large chains, groups, or stadium/event employers",
                features: [
                    "Unlimited job posts - unlimited locations",
                    "Daily push promo available (for accom or hangout)",
                    "Branded careers page",
                    "Team logins (multi-manager access)",
                    "Internal HR tools, Recruiters, Enterprise ATS"
                ],
                productID: "com.shiftly.app.subscription.headOffice",
                duration: "1 month",
                localization: "Missing Metadata"
            )
        ]
    }
    
    // MARK: - Fetch a specific plan by tier
    func getPlan(for tier: SubscriptionTier) -> SubscriptionPlan? {
        return getAllPlans().first { $0.tier == tier }
    }
    
    // MARK: - Get user's active plan (dummy for now)
    func getActivePlan() -> SubscriptionPlan {
        // In real use case, fetch from backend or saved user info
        return getPlan(for: .basic)!
    }
    
    // MARK: - Compare tiers (for feature access control)
    func canAccessFeature(requiredTier: SubscriptionTier) -> Bool {
        let tiers = SubscriptionTier.allCases
        guard let currentIndex = tiers.firstIndex(of: getActivePlan().tier),
              let requiredIndex = tiers.firstIndex(of: requiredTier) else {
            return false
        }
        return currentIndex >= requiredIndex
    }
}

