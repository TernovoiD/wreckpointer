//
//  OverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.08.2023.
//

import SwiftUI

struct OverlayView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        VStack {
            MapSearchBar()
            ZStack {
                SelectedWreckPanel()
                    .offset(x: appState.activeUIElement == .mapSelected ? 0 : 1000)
                MapButtonsView()
                    .offset(x: appState.activeUIElement == .mapSearch || appState.activeUIElement == .mapSelected ? -1000 : 0)
                SearchList()
                    .offset(x: appState.activeUIElement == .mapSearch ? 0 : 1000)
            }
            Spacer()
        }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.mint.ignoresSafeArea()
            OverlayView()
                .environmentObject(AppState())
                .environmentObject(AppData())
        }
    }
}
