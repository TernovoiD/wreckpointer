//
//  HomeView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomePageViewModel()
    @EnvironmentObject var store: PurchasesManager
    @State var presentedWreck: Wreck?
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Welcome to Wreckpointer.project, where the fascination for shipwrecks and history connects enthusiasts from across the globe! Delve into the depths of maritime heritage as we bring together a community passionate about exploring shipwrecks and their captivating histories.")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal)
                WreckSelector(wrecks: $viewModel.random5Wrecks)
                lastApproved
                .padding()
                modernHistory
                .padding()
                Image("ship2")
                    .resizable()
                    .frame(maxHeight: 300)
                
            }
            .task {
                await viewModel.loadWrecks()
            }
            .navigationTitle("Wreckpointer")
            .sheet(item: $presentedWreck) { wreck in
                WreckView(wreck: wreck)
            }
            .toolbar {
                if !store.hasPRO {
                    NavigationLink(".PRO") {
                        PROSubscriptions()
                    }
                }
            }
        }
    }
    
    private var lastApproved: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Color.green)
                Text("Last approved:")
            }
            .font(.title2.bold())
            Text("Don't forget to check newly verified shipwrecks. Our database is regularly updated to provide you with the most recent information on shipwrecks from various eras and locations across the globe.")
                .font(.callout)
                .foregroundStyle(Color.secondary)
            ForEach(viewModel.random5Wrecks) { wreck in
                NavigationLink {
                    WreckView(wreck: wreck)
                } label: {
                    HStack(alignment: .top) {
                    ImageView(imageData: .constant(wreck.image))
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(wreck.hasName)
                            .font(.headline.weight(.bold))
                        if wreck.hasDateOfLoss.isValid {
                            Text("Date of loss: \(wreck.hasDateOfLoss.date.formatted(date: .abbreviated, time: .omitted))")
                        }
                        Text("Type: \(wreck.hasType.description)")
                        Text("Cause: \(wreck.hasCause.description)")
                    }
                    .font(.caption)
                    Spacer()
                    VStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                    }
                }
                    .foregroundStyle(Color.primary)
                }
            }
        }
    }
    
    private var modernHistory: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "ferry")
                    .foregroundStyle(Color.accentColor)
                Text("Modern history")
            }
            .font(.title2.bold())
            Text("These submerged relics reveal not just the tragedies but also the evolving technological advancements, environmental impacts, and the human narratives behind these contemporary maritime mysteries.")
                .font(.callout)
                .foregroundStyle(Color.secondary)
            ForEach(viewModel.random5Wrecks) { wreck in
                NavigationLink {
                    WreckView(wreck: wreck)
                } label: {
                    WreckPlateView(wreck: wreck)
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomePageViewModel())
        .environmentObject(PurchasesManager())
}
