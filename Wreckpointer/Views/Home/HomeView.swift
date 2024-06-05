//
//  HomeView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 04.01.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomePageViewModel()
    @State var presentedWreck: Wreck?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    Text("Welcome to Wreckpointer.project, where the fascination for shipwrecks and history connects enthusiasts from across the globe!")
                        .font(.callout)
                        .foregroundStyle(Color.secondary)
                        .padding(.horizontal)
                    if viewModel.loading {
                        ProgressView()
                            .scaleEffect(2)
                            .padding(50)
                    } else {
                        WreckSelector(wrecks: $viewModel.random5Wrecks)
                        lastApproved
                            .padding()
                            .padding(.top)
                        modernHistory
                            .padding()
                        Image("ship2")
                            .resizable()
                            .frame(maxHeight: 300)
                    }
                }
                .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
                    Button("OK", role: .cancel) { }
                }
                .navigationTitle("Wreckpointer")
                .sheet(item: $presentedWreck) { wreck in
                    WreckView(wreck: wreck)
                }
            }
        }
    }
    
    private var lastApproved: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Color.green)
                Text("Last updated:")
            }
            .font(.title2.bold())
            Text("Don't forget to check newly verified shipwrecks. Our database is regularly updated to provide you with the most recent information on shipwrecks from various eras and locations across the globe.")
                .font(.callout)
                .foregroundStyle(Color.secondary)
            ForEach(viewModel.last3ApprovedWrecks) { wreck in
                NavigationLink {
                    WreckView(wreck: wreck)
                } label: {
                    WreckPlateView(wreck: wreck)
                }
            }
        }
    }
    
    private var modernHistory: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "ferry")
                    .foregroundStyle(Color.accent)
                Text("Modern history")
            }
            .font(.title2.bold())
            Text("These submerged relics reveal not just the tragedies but also the evolving technological advancements, environmental impacts, and the human narratives behind these contemporary maritime mysteries.")
                .font(.callout)
                .foregroundStyle(Color.secondary)
            ForEach(viewModel.modernHistory6Wrecks) { wreck in
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
}
