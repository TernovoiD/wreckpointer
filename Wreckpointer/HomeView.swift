//
//  HomeView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.08.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appData: AppData
    @State private var loading: Bool = true
    @State private var overlay: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView()
                if appState.activeUIElement == .mapFilter || appState.activeUIElement == .mapMenu || appState.activeUIElement == .mapSettings || appState.activeUIElement == .mapSearch {
                    Color.clear.background(.ultraThinMaterial).ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                appState.activeUIElement = .none
                            }
                        }
                }
                OverlayView()
                LoadingView(show: $loading)
            }
            .task { if appState.authorizedUser == nil { await appState.fetchUser() } }
            .task { if appData.collections.isEmpty { await appData.loadCollections() } }
        }
        .onChange(of: appData.serverData) { newState in
            if newState != .loading { turnLoadingOff() }
        }
    }
    
    private func turnLoadingOff() {
        withAnimation(.easeInOut) {
            loading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                withAnimation(.easeInOut) {
                    overlay = true
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}
