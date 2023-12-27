//
//  MapSearchBarView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapSearchBarView: View {
    @EnvironmentObject var data: WreckpointerData
    @FocusState private var searchFieldSelected: Bool
    @Binding var mapSelectedWreck: Wreck?
    
    var body: some View {
        VStack {
            searchTextField
                .padding()
            if !viewModel.searched(wrecks: wreckpointerData.wrecks).isEmpty {
                Divider()
                searchedWrecksList
            }
        }
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
            ForEach(viewModel.searched(wrecks: wreckpointerData.wrecks)) { wreck in
                Button {
                    viewModel.selectedWreck = wreck
                } label: {
                    WreckRowView(wreck: wreck)
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .frame(maxHeight: 200)
    }
    
    private func dismissSearch() {
        viewModel.textToSearch = ""
        searchFieldSelected = false
    }
    
    //    func minimumDateOfLossDate(forWrecks allWrecks: [Wreck]) {
    //        var datesArray: [Date] = [ ]
    //        let wrecks = allWrecks.filter({ $0.dateOfLoss != nil })
    //
    //        if wrecks.isEmpty {
    //            minimumDateFilter = Date()
    //        } else {
    //            for wreck in wrecks {
    //                datesArray.append(wreck.dateOfLoss ?? Date())
    //            }
    //            minimumDateFilter = datesArray.min() ?? Date()
    //        }
    //    }
}

#Preview {
    MapSearchBarView(viewModel: MapViewModel())
        .environmentObject(WreckpointerData())
        .padding(.horizontal)
}
