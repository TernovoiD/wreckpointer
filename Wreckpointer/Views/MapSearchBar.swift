//
//  MapSearchBar.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapSearchBar: View {
    
    @FocusState private var searchFieldSelected: Bool
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        HStack {
            searchBar
            if !appData.textToSearch.isEmpty {
                searchBarClearButton
            }
        }
        .padding(.horizontal)
        .onChange(of: appState.selectedWreck, perform: { _ in searchFieldSelected = false })
        .onChange(of: appState.activeUIElement) { activeUIElement in
            withAnimation(.easeInOut) {
                if activeUIElement == .mapSearch {
                    searchFieldSelected = true
                    appState.select(wreck: nil)
                } else {
                    searchFieldSelected = false
                }
            }
        }
    }
}

struct MapSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchBar()
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}


// MARK: - Variables

extension MapSearchBar {
    
    private var searchBar: some View {
        TextField("Search", text: $appData.textToSearch.animation(.easeInOut))
            .padding()
            .focused($searchFieldSelected)
            .neonField(light: searchFieldSelected ? true : false)
            .submitLabel(.search)
            .autocorrectionDisabled(true)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    appState.activate(element: .mapSearch)
                }
            }
            .onSubmit {
                withAnimation(.easeInOut) {
                    appState.activate(element: .none)
                }
            }
    }
    
    private var searchBarClearButton: some View {
        Button {
            withAnimation(.easeInOut) {
                appState.activate(element: .none)
                appData.textToSearch = ""
                searchFieldSelected = false
            }
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
                .padding()
                .background(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: .green, radius: 7)
        }
    }
}
