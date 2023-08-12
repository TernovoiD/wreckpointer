//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @AppStorage("visitedCollections") var visitedCollections: Bool = false
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            MapSearchBar()
            ZStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        MapMenu()
                        collectionsButton
                        Spacer()
                    }
                    MapSettings()
                    MapFilter()
                }
                .offset(x: !wrecks.textToSearch.isEmpty ? -1000 : 0)
                SearchList()
                    .offset(x: !wrecks.textToSearch.isEmpty ? 0 : 1000)
            }
            .padding(.horizontal)
            Spacer()
            if let wreck = wrecks.selectedWreck {
                SelectedWreckPanel(wreck: wreck)
                    .offset(y: -40)
            }
        }
    }
    
    private var collectionsButton: some View {
        NavigationLink {
            CollectionsView()
        } label: {
            Text("Collections")
                .frame(height: 35)
                .font(.headline)
                .padding()
                .accentColorBorder()
                .overlay(alignment: .topTrailing) {
                    if !visitedCollections {
                        Text("New!")
                            .font(.caption2)
                            .bold()
                            .padding(3)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            .offset(x: 5, y: -5)
                    }
                }
        }
    }
}

struct MapOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        MapOverlayView()
            .environmentObject(Wrecks())
            .environmentObject(AppState())
    }
}
