//
//  MapSearchBar.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapSearchBar: View {
    
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    @FocusState var searchFieldSelected: Bool
    
    var body: some View {
        HStack {
            searchBar
            if !wrecks.textToSearch.isEmpty {
                searchBarClearButton
            }
        }
        .padding(.horizontal)
        .onChange(of: state.activeUIElement) { newValue in
            withAnimation(.easeInOut) {
                if newValue == .mapSearch {
                    searchFieldSelected = true
                } else {
                    searchFieldSelected = false
                }
            }
        }
    }
    
    private var searchBar: some View {
        TextField("Search", text: $wrecks.textToSearch.animation(.easeInOut))
            .padding()
            .focused($searchFieldSelected)
            .background(wrecks.filtered.count == 0 && !wrecks.textToSearch.isEmpty ? Color.red.opacity(0.3) : Color.clear)
            .neonField(light: searchFieldSelected ? true : false)
            .submitLabel(.search)
            .autocorrectionDisabled(true)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    state.activeUIElement = .mapSearch
                }
            }
            .onSubmit {
                withAnimation(.easeInOut) {
                    state.activeUIElement = .none
                }
            }
    }
    
    private var searchBarClearButton: some View {
        Button {
            withAnimation(.easeInOut) {
                state.activeUIElement = .none
                wrecks.textToSearch = ""
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

struct MapSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchBar()
            .environmentObject(Wrecks())
            .environmentObject(AppState())
    }
}
