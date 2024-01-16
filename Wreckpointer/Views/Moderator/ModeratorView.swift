//
//  ModeratorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI

struct ModeratorView: View {
    
    @StateObject var viewModel = ModeratorViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.searchedWrecks) { wreck in
                        NavigationLink {
                            AddUpdateWreckView(moderatorVM: viewModel, wreck: wreck)
                        } label: {
                            WreckRowView(wreck: wreck, arrow: false)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Moderator")
                .searchable(text: $viewModel.textToSearch)
                .refreshable {
                    Task {
                        await viewModel.loadWrecks()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Sign Out") {
                            viewModel.sighOut()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Toggle("Unapproved", isOn: $viewModel.unapprovedOnly)
                            .padding(.horizontal)
                    }
                    ToolbarItem {
                        EditButton()
                    }
                    
                }
            }
            LoginPageView(viewModel: viewModel)
                .offset(x: viewModel.user == nil ? 0 : 1000)
        }
        .task {
            await viewModel.authorize()
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.delete(wreck: viewModel.searchedWrecks[index])
            }
        }
    }
}

#Preview {
    ModeratorView()
        .environmentObject(ModeratorViewModel())
}
