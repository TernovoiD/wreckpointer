//
//  PurchasesManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.01.2024.
//

import Foundation
import StoreKit

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
    
    let productIds = [Subscriptions.monthly.id, Subscriptions.yearly.id]
    @Published private(set) var subscriptions: [Product] = [ ]
    @Published private(set) var purchasedSubscriptions: [Product] = [ ]
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    var hasPRO: Bool {
        switch purchasedSubscriptions.isEmpty {
        case true:
            return false
        case false:
            return true
        }
    }

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
                print()
            }
        }
        self.purchasedSubscriptions = purchasedSubscriptions
        subscriptionGroupStatus = try? await subscriptions.first?.subscription?.status.first?.state
    }
}
