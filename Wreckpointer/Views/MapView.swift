//
//  MapView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {

    @AppStorage("saveWrecksInMemory") private var saveWrecksInMemory: Bool = true
    @StateObject var viewModel = MapViewModel()
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    
    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: wrecks.filtered) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                MapPinView(wreck: wreck)
                    .environmentObject(wrecks)
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Map")
        .toolbar(.hidden)
        .onTapGesture { deselectAll() }
        .task { await loadWrecks() }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: wrecks.selectedWreck, perform: { newValue in moveMap(newPosition: newValue) })
        .onChange(of: saveWrecksInMemory) { newValue in memorySave(newRule: newValue)}
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(Wrecks())
            .environmentObject(AppState())
    }
}


// MARK: - Functions

extension MapView {
    
    private func memorySave(newRule: Bool) {
        print("we are here")
        if newRule {
            viewModel.saveInMemory(wrecks: wrecks.all)
        } else {
            viewModel.deleteWrecksFromMemory()
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
            state.activeUIElement = .none
            wrecks.selectedWreck = nil
        }
    }
    
    private func loadWrecks() async {
        if wrecks.all.isEmpty {
            if saveWrecksInMemory,
               let memoryWrecks = viewModel.loadWrecksFromCoreData() {
                wrecks.all = memoryWrecks
            }
            if let loadedWrecks = await viewModel.loadWrecksFromServer() {
                wrecks.all = loadedWrecks
                if saveWrecksInMemory {
                    viewModel.saveInMemory(wrecks: loadedWrecks)
                }
            }
        }
    }
}
