//
//  ModeratorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 29.12.2023.
//

import SwiftUI

struct ModeratorView: View {
    
    @EnvironmentObject var data: WreckpointerData
    @StateObject var viewModel = ModeratorViewModel()
    @State var textToSearch = ""
    @State var wreckTypeFilter: WreckTypes?
    @State var wreckCauseFilter: WreckCauses?
    @State var wreckDiverOnlyFilter: Bool = false
    @State var unapprovedOnly: Bool = false
    
    var filteredWrecks: [Wreck] {
        var filteredWrecks = data.wrecks
        
        if wreckTypeFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasType == wreckTypeFilter })
        }
        if wreckCauseFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasCause == wreckCauseFilter })
        }
        if wreckDiverOnlyFilter {
            filteredWrecks = filteredWrecks.filter({ $0.isWreckDive == true })
        }
        if unapprovedOnly {
            filteredWrecks = filteredWrecks.filter({ $0.isApproved == false })
        }
        if !textToSearch.isEmpty {
            filteredWrecks = filteredWrecks.filter({
                $0.hasName.lowercased().contains(textToSearch.lowercased())
            })
        }
        return filteredWrecks.sorted(by: { $0.hasUpdate.date > $1.hasUpdate.date })
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    VStack {
                        wreckTypePicker
                        wreckCausePicker
                        Toggle("Wreck dives only", isOn: $wreckDiverOnlyFilter)
                        Toggle("Unapproved only", isOn: $unapprovedOnly)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    Divider()
                    List {
                        ForEach(filteredWrecks) { wreck in
                            NavigationLink(wreck.hasName) {
                                EditWreckView(wreckID: wreck.id, moderator: true)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                delete(wreck: filteredWrecks[index])
                            }
                        })
                    }
                    .searchable(text: $textToSearch)
                    .listStyle(.plain)
                }
                .navigationTitle("Moderator")
                .toolbar {
                    ToolbarItem() {
                        Button("Sign Out") {
                            viewModel.sighOut()
                        }
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
    
    private func delete(wreck: Wreck) {
        Task {
            await data.delete(wreck: wreck)
        }
    }
    
    private var wreckTypePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $wreckTypeFilter) {
                Text("All")
                    .tag(WreckTypes?.none)
                ForEach(WreckTypes.allCases) { type in
                    Text(type.description)
                        .tag(WreckTypes?.some(type))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var wreckCausePicker: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck type", selection: $wreckCauseFilter) {
                Text("All")
                    .tag(WreckCauses?.none)
                ForEach(WreckCauses.allCases) { cause in
                    Text(cause.description)
                        .tag(WreckCauses?.some(cause))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    ModeratorView()
        .environmentObject(ModeratorViewModel())
        .environmentObject(WreckpointerData())
}
