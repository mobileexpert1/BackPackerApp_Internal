//
//  SubscriptionManager.swift
//  Backpacker
//
//  Created by Mobile on 07/10/25.
//

import Foundation
import StoreKit
import CryptoKit
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
    var regionCode : String?
    private init() {
        // Start listening for ongoing or new transactions
        Task.detached { [weak self] in
            await self?.listenForTransactions()
        }
    }
    
    // MARK: - Stored Property
    private(set) var activePlan: SubscriptionPlan?
    
    var selectedPlan : SubscriptionTier?
    var purchasePlanDetail : CreateUserPlanRequest?
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
    /*
     productID: "com.shiftly.app.subscription.headOffice"
     productID: "com.shiftly.app.subscription.pro",
     productID: "com.shiftly.app.subscription.growth",
     productID: "com.shiftly.app.subscription.basic",
     */
    func fetchLocalizedPricesForAllPlans() async -> (prices: [String: String], region: String) {
        var priceMap: [String: String] = [:]
        
        LoaderManager.shared.show()
        
        let productIDs = getAllPlans().compactMap { $0.productID }
        
        do {
            let products = try await Product.products(for: productIDs)
            let regionCode = SKPaymentQueue.default().storefront?.countryCode ?? ""
            
            for product in products {
                priceMap[product.id] = product.displayPrice
            }
            
            return (priceMap, regionCode)
            
        } catch {
            print("Error: \(error)")
            return ([:], "Unknown")
        }
    }
    
    
    func getAppStoreRegion() -> String? {
        if let storefront = SKPaymentQueue.default().storefront {
            return storefront.countryCode // Example: "US", "IN", "AE"
        }
        return nil
    }
    
    
    // MARK: - Get plan by tier
    func getPlan(for tier: SubscriptionTier) -> SubscriptionPlan? {
        getAllPlans().first { $0.tier == tier }
    }
    func uuidFromString(_ string: String) -> UUID {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        let hashBytes = [UInt8](hash)
        
        return UUID(uuid: (
            hashBytes[0], hashBytes[1], hashBytes[2], hashBytes[3],
            hashBytes[4], hashBytes[5], hashBytes[6], hashBytes[7],
            hashBytes[8], hashBytes[9], hashBytes[10], hashBytes[11],
            hashBytes[12], hashBytes[13], hashBytes[14], hashBytes[15]
        ))
    }
    
    //----------: -  This method is used to convert USerID to UUID format becasue in backend for webhooke we have to establish the connecton which user i purchased so we can pass it   "appAccountToken" , so they will decod UUID to userid in nodeJS, so They can mainteni weghooke for both platform iOS and android -----------------
    func encodeObjectIdToUUID(_ objectId: String) -> UUID? {
        
        guard objectId.count == 24 else {
            print("❌ Invalid ObjectId length")
            return nil
        }
        
        var bytes = [UInt8]()
        var startIndex = objectId.startIndex
        
        for _ in 0..<12 {
            let nextIndex = objectId.index(startIndex, offsetBy: 2)
            let pair = objectId[startIndex..<nextIndex]
            
            guard let byte = UInt8(pair, radix: 16) else { return nil }
            
            bytes.append(byte)
            startIndex = nextIndex
        }
        
        // pad 4 bytes for UUID (total 16 bytes)
        bytes.append(contentsOf: [0, 0, 0, 0])
        
        // convert to hex string
        let hex = bytes.map { String(format: "%02x", $0) }.joined()
        
        // break into UUID parts to avoid compiler error
        let part1 = String(hex.prefix(8))
        let part2 = String(hex.dropFirst(8).prefix(4))
        let part3 = String(hex.dropFirst(12).prefix(4))
        let part4 = String(hex.dropFirst(16).prefix(4))
        let part5 = String(hex.dropFirst(20))
        
        let uuidString = "\(part1)-\(part2)-\(part3)-\(part4)-\(part5)"
        
        return UUID(uuidString: uuidString.uppercased())
    }
    
    
    // MARK: - Purchase Plan
    func purchasePlan(tier: SubscriptionTier) async {
        guard let plan = getPlan(for: tier),
              let productID = plan.productID else {
            print(" Invalid plan or product ID")
            return
        }
        
        do {
            let products = try await Product.products(for: [productID])
            guard let product = products.first else {
                print(" Product not found on App Store")
                return
            }
            let udisd = encodeObjectIdToUUID(UserDefaultsManager.shared.employeruserId!)
            let options: Set<Product.PurchaseOption> = [
                .appAccountToken(udisd!)
            ]
            let result = try await product.purchase(options: options)
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await handle(transaction)
                await transaction.finish()
                print("Transcation",transaction)
                print("Verification",verification)
                print(" Purchase successful for \(tier.rawValue)")
                if let vc = self.controller {
                    AlertManager.showAlert(
                        on: vc,
                        title: "Purchase Successful",
                        message: """
                        Your \(tier.rawValue) subscription has been successfully activated.

                        Please note: It may take up to 1 minute for your plan to reflect in the app.
                        """
                    )
                }

                let purchaseRequest = createUserPlanRequest(from: transaction)
                self.purchasePlanDetail = purchaseRequest
            case .userCancelled:
                print("User cancelled purchase")
                if let vc = self.controller{
                    AlertManager.showAlert(
                        on: vc,
                        title: "Purchase Cancelled",
                        message: "You have cancelled the subscription process. You can try again anytime from the subscription screen."
                    )
                }
            case .pending:
                print("Purchase pending")
                if let vc = self.controller{
                    AlertManager.showAlert(
                        on: vc,
                        title: "Purchase Pending",
                        message: "Your purchase is currently pending. Please wait for the transaction to complete or check your App Store account for updates."
                    )
                }
                
                
            @unknown default:
                print("Unknown purchase result")
                guard let controllers = self.controller else {
                    print("No controller available to show alerts or loader.")
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
            print("Purchase failed: \(error.localizedDescription)")
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
                print("Transaction update verification failed: \(error)")
            }
        }
    }
    // MARK: - Handle verified transaction
    private func handle(_ transaction: Transaction) async {
        guard let plan = getAllPlans().first(where: { $0.productID == transaction.productID }) else { return }
        
        // Save active plan
        activePlan = plan
        saveActiveTier(plan.tier)
        
        print("Transaction handled for plan: \(plan.tier.rawValue)")
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async -> Bool {
        var restored = false
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                await handle(transaction)
                restored = true
            } catch {
                print("Restore failed for a transaction: \(error.localizedDescription)")
            }
        }
        
        return restored
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
    func createUserPlanRequest(from transaction: Transaction) -> CreateUserPlanRequest {
        return CreateUserPlanRequest(
            appTransactionId: String(transaction.id),
            transactionId: String(transaction.id),
            transactionReason: "PURCHASE",
            purchaseDate: Int(transaction.purchaseDate.timeIntervalSince1970 * 1000),
            expiresDate: Int(transaction.expirationDate?.timeIntervalSince1970 ?? 0 * 1000),
            originalPurchaseDate: Int(transaction.originalPurchaseDate.timeIntervalSince1970 * 1000),
            originalTransactionId: String(transaction.originalID),
            productId: transaction.productID,
            bundleId: Bundle.main.bundleIdentifier ?? "",
            platformType: "ios",
            quantity: transaction.purchasedQuantity,
            type: "Auto-Renewable Subscription",
            currency: "USD",
            price: NSDecimalNumber(decimal: transaction.price ?? 0).doubleValue,
            subscriptionId: UUID().uuidString
        )
    }
    
}

