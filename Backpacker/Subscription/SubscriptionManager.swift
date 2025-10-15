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
    case free = "Free / Starter Plan"
    case basic = "Basic Plan"
    case growth = "Growth Plan"
    case pro = "Pro Plan"
    case headOffice = "Head Office Plan"
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
import Foundation
import StoreKit

@MainActor
final class SubscriptionManager {
    
    static let shared = SubscriptionManager()
    
    private init() {
        // Start listening for ongoing or new transactions
        Task.detached { [weak self] in
            await self?.listenForTransactions()
        }
    }
    
    // MARK: - Stored Property
    private(set) var activePlan: SubscriptionPlan?
    
    var selectedPlan : SubscriptionTier?
    var controller : UIViewController?
    // MARK: - Fetch all available plans
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
    
    // MARK: - Get plan by tier
    func getPlan(for tier: SubscriptionTier) -> SubscriptionPlan? {
        getAllPlans().first { $0.tier == tier }
    }
    
    // MARK: - Purchase Plan
    func purchasePlan(tier: SubscriptionTier) async {
        guard let plan = getPlan(for: tier),
              let productID = plan.productID else {
            print("❌ Invalid plan or product ID")
            return
        }
        
        do {
            let products = try await Product.products(for: [productID])
            guard let product = products.first else {
                print("❌ Product not found on App Store")
                return
            }
            
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await handle(transaction)
                await transaction.finish()
                print("Transcation",transaction)
                print("Verification",verification)
                print("✅ Purchase successful for \(tier.rawValue)")
                if let vc = self.controller{
                    AlertManager.showAlert(
                               on: vc,
                               title: "Purchase Successful",
                               message: "Your \(tier.rawValue) subscription has been successfully activated. Enjoy your premium features!"
                           )
                }
                
            case .userCancelled:
                print("🟡 User cancelled purchase")
                if let vc = self.controller{
                    AlertManager.showAlert(
                        on: vc,
                        title: "Purchase Cancelled",
                        message: "You have cancelled the subscription process. You can try again anytime from the subscription screen."
                    )
                }
            case .pending:
                print("⏳ Purchase pending")
                if let vc = self.controller{
                    AlertManager.showAlert(
                        on: vc,
                        title: "Purchase Pending",
                        message: "Your purchase is currently pending. Please wait for the transaction to complete or check your App Store account for updates."
                    )
                }
               
                
            @unknown default:
                print("❓ Unknown purchase result")
                guard let controllers = self.controller else {
                        print("⚠️ No controller available to show alerts or loader.")
                        return
                    }
                if let vc = self.controller{
                    AlertManager.showAlert(
                        on: vc,
                        title: "Unknown Status",
                        message: "An unexpected issue occurred during the purchase process. Please try again later."
                    )
                }
               
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Listen for ongoing transactions (background, renewals, etc.)
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)
                await handle(transaction)
                await transaction.finish()
            } catch {
                print("❌ Transaction update verification failed: \(error)")
            }
        }
    }
    
    // MARK: - Verify transactions
    private func checkVerified(_ result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let transaction):
            return transaction
        }
    }

    
    // MARK: - Handle verified transaction
    private func handle(_ transaction: Transaction) async {
        guard let plan = getAllPlans().first(where: { $0.productID == transaction.productID }) else { return }
        
        // Save active plan
        activePlan = plan
        saveActiveTier(plan.tier)
        
        print("✅ Transaction handled for plan: \(plan.tier.rawValue)")
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                await handle(transaction)
            } catch {
                print("❌ Restore failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Tier Access Control
    func canAccessFeature(requiredTier: SubscriptionTier) -> Bool {
        let tiers = SubscriptionTier.allCases
        guard let activeTier = activePlan?.tier ?? loadActiveTier(),
              let currentIndex = tiers.firstIndex(of: activeTier),
              let requiredIndex = tiers.firstIndex(of: requiredTier) else {
            return false
        }
        return currentIndex >= requiredIndex
    }
    
    // MARK: - Persistence
    private let activeTierKey = "activeSubscriptionTier"
    
    private func saveActiveTier(_ tier: SubscriptionTier) {
        UserDefaults.standard.set(tier.rawValue, forKey: activeTierKey)
    }
    
    private func loadActiveTier() -> SubscriptionTier? {
        guard let raw = UserDefaults.standard.string(forKey: activeTierKey) else { return nil }
        return SubscriptionTier(rawValue: raw)
    }
}
