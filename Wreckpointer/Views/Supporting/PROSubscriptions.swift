//
//  SubscriptionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.01.2024.
//

import SwiftUI
import StoreKit

struct PROSubscriptions: View {
    
    @EnvironmentObject var store: PurchasesManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            backgroundImage
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Remove ads and get a gorgeous widget! Wreckpointer.project, thrives with your support!")
                        .font(.callout)
                        .foregroundStyle(Color.secondary)
                        .padding(.vertical)
                    VStack(spacing: 10) {
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
        PROSubscriptions()
            .environmentObject(PurchasesManager())
    }
}

struct SubscriptionButtonView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 5) {
                HStack(alignment: .center) {
                    Text(product.displayName)
                        .foregroundStyle(Color.primary)
                    Spacer()
                    Text(product.displayPrice)
                        .foregroundStyle(Color.accent)
                }
                .font(.headline.weight(.black))
            }
        }
        .padding()
        .coloredBorder(color: .primary)
    }
}
