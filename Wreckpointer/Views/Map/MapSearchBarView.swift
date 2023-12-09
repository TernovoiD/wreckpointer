//
//  MapSearchBarView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapSearchBarView: View {
    
    @EnvironmentObject var wreckpointerData: WreckpointerData
    @ObservedObject var viewModel: MapViewModel
    @FocusState private var searchFieldSelected: Bool
    
    var body: some View {
        VStack {
            searchTextField
            if !viewModel.searched(wrecks: wreckpointerData.wrecks).isEmpty {
                Divider()
                searchedWrecksList
            }
        }
        .padding()
        .coloredBorder(color: searchFieldSelected ? .accentColor : .gray)
    }
    
    private var searchTextField: some View {
        HStack {
            TextField("RMS Titanic", text: $viewModel.textToSearch.animation(.easeInOut))
                .focused($searchFieldSelected)
                .submitLabel(.search)
                .autocorrectionDisabled(true)
            Button(action: dismissSearch, label: {
                Image(systemName: "xmark")
                    .font(.headline.bold())
            })
        }
    }
    
    private var searchedWrecksList: some View {
        List {
            ForEach(viewModel.filtered(wrecks: wreckpointerData.wrecks)) { wreck in
                Button {
                    viewModel.selectedWreck = wreck
                } label: {
                    WreckRowView(wreck: wreck)
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .background(.ultraThinMaterial)
        .frame(maxHeight: viewModel.textToSearch.isEmpty || viewModel.filtered(wrecks: wreckpointerData.wrecks).count == 0 ? 0 : 200)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
    
    private func dismissSearch() {
        viewModel.textToSearch = ""
        searchFieldSelected = false
    }
}

#Preview {
    MapSearchBarView(viewModel: MapViewModel())
        .environmentObject(WreckpointerData())
        .padding(.horizontal)
}
