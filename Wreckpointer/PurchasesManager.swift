//
//  PurchasesManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.01.2024.
//

import Foundation
import StoreKit
import WidgetKit
import SwiftUI

typealias Transaction = StoreKit.Transaction
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

enum StoreError: Error {
    case failedVerification
}

enum Subscriptions {
    case monthly
    case yearly
    
    var id: String {
        switch self {
        case .monthly:
            return "Wreckpointer.PRO.monthly"
        case .yearly:
            return "Wreckpointer.PRO.yearly"
        }
    }
}

class PurchasesManager: ObservableObject {
    @AppStorage("proSubscription", store: UserDefaults(suiteName: "group.MWQ8P93RWJ.com.danyloternovoi.Wreckpointer")) 
    var proSubscription: Bool = false
    
    let productIds = [Subscriptions.monthly.id, Subscriptions.yearly.id]
    @Published private(set) var subscriptions: [Product] = [ ]
    @Published private(set) var purchasedSubscriptions: [Product] = [ ]
    
    var updateListenerTask: Task<Void, Error>? = nil

    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    private func requestProducts() async  {
        do {
            subscriptions = try await Product.products(for: productIds)
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            return true
        case .userCancelled, .pending:
            return false
        default:
            return false
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedSubscriptions: [Product] = []
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
            } catch {
                // do nothing
            }
        }
        self.purchasedSubscriptions = purchasedSubscriptions
        self.proSubscription = !self.purchasedSubscriptions.isEmpty
        WidgetCenter.shared.reloadAllTimelines()
    }
}
