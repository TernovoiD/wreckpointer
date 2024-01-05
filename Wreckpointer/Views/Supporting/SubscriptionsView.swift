//
//  SubscriptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.01.2024.
//

import SwiftUI
import StoreKit

struct SubscriptionsView: View {
    
    @EnvironmentObject var store: PurchasesManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            backgroundImage
            ScrollView {
                VStack {
                    Text("Get a .PRO subscription to support this exceptionally unique and niche app on the App Store. Your subscription guarantees continual advancements for Wreckpointer.project, granting you access to all wrecks, a selection of widgets, and the ability to load the database for offline app usage. Join our dedicated community today and become an essential part of enhancing and shaping the future of Wreckpointer.project!")
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                        .padding(.vertical)
                    HStack(spacing: 10) {
                        ForEach(store.subscriptions) { subscription in
                            Button(action: {
                                Task {
                                    await subscribe(product: subscription)
                                }
                            }, label: {
                                SubscriptionButtonView(product: subscription)
                            })
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(".PRO")
        }
    }
    
    private var backgroundImage: some View {
        VStack {
            Spacer()
            Image("ship3")
                .resizable()
                .frame(maxHeight: 300)
        }
    }
    
    private func subscribe(product: Product) async{
        do {
            let success = try await store.purchase(product)
            if success {
                dismiss()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationView {
        SubscriptionsView()
            .environmentObject(PurchasesManager())
    }
}

struct SubscriptionButtonView: View {
    
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text(product.displayName)
                    .font(.footnote.weight(.black))
                    .foregroundStyle(Color.primary)
                Text(product.displayPrice)
                    .foregroundStyle(Color.accentColor)
            }
            .frame(maxHeight: 20)
            Text(product.description)
                .font(.caption2)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: 150, maxHeight: 30)
        }
        .padding(.vertical)
        .padding(.horizontal, 10)
        .coloredBorder(color: .primary)
    }
}
