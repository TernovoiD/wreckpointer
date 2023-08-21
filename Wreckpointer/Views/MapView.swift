//
//  MapView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @AppStorage("saveWrecksInMemory") private var saveWrecksInMemory: Bool = false
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: appData.wrecksFiltered) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                Image(systemName: "smallcircle.filled.circle.fill")
                    .font(.caption2)
                    .onTapGesture { select(wreck: wreck) }
                    .scaleEffect(appState.selectedWreck != nil && appState.selectedWreck != wreck ? 1 : 1.5)
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Map")
        .toolbar(.hidden)
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: appState.selectedWreck, perform: { newValue in moveMap(newPosition: newValue) })
        .task {
            await loadWrecks()
        }
    }
    
    private func select(wreck: Wreck?) {
        withAnimation(.easeInOut) {
            appState.select(wreck: wreck)
        }
    }
    
    private func loadWrecks() async {
        if saveWrecksInMemory && appData.coreData != .uploaded {
            appData.loadWrecksFromCoreData()
        }
        if appData.serverData != .ready {
            await appData.loadWrecksFromServer()
        }
    }
    
    private func moveMap(newPosition: Wreck?) {
        if let wreck = newPosition {
            withAnimation(.easeInOut) {
                viewModel.changeMapRegion(latitude: wreck.latitude, longitude: wreck.longitude)
            }
        }
    }
    
    private func deselectAll() {
        withAnimation(.easeInOut) {
            if appState.selectedWreck != nil {
                appState.select(wreck: nil)
            }
            appState.activate(element: .none)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}
