//
//  MapView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var appData: WreckpointerData
    @State var active: Bool = false
    
    var body: some View {
        ZStack {
            map
                .ignoresSafeArea(edges: .top)
                .onChange(of: viewModel.selectedWreck, perform: { selectedWreck in moveMap(to: selectedWreck) })
                .onTapGesture { dismissActiveUIElement() }
            if viewModel.activeMapOverlayElement != .none {
                Color.clear
                    .background(.ultraThinMaterial)
                    .onTapGesture(perform: dismissActiveUIElement)
            }
            overlay
                .padding(.top)
        }
    }
    
    private var map: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.filtered(wrecks: appData.wrecks)) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude, longitude: wreck.longitude)) {
                Image(systemName: "signpost.and.arrowtriangle.up.circle.fill")
                    .font(.caption2)
                    .onTapGesture {
                        viewModel.selectedWreck = wreck
                    }
                    .scaleEffect(viewModel.selectedWreck == wreck ? 1.5 : 1)
            }
        }
    }
    
    private var overlay: some View {
        VStack {
            MapPanelView(viewModel: viewModel)
            Spacer()
        }
    }
    
    private func moveMap(to selectedWreck: Wreck?) {
        guard let wreck = selectedWreck else { return }
        withAnimation(.easeInOut) {
            viewModel.changeMapRegion(latitude: wreck.latitude, longitude: wreck.longitude)
        }
    }
    
    private func dismissActiveUIElement() {
        withAnimation(.bouncy) {
            viewModel.activeMapOverlayElement = .none
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(WreckpointerData())
    }
}
