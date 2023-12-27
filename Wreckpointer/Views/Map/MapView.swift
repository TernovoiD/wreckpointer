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
            if viewModel.activeMapOverlayElement != .none {
//                Color.clear
//                    .background(.ultraThinMaterial)
//                    .onTapGesture(perform: dismissActiveUIElement)
                Color.black.opacity(0.8)
                    .onTapGesture(perform: dismissActiveUIElement)
                    .ignoresSafeArea()
            }
            overlay
                .padding(.top)
                .padding(.bottom)
        }
    }
    
    private var map: some View {
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.filtered(wrecks: appData.wrecks)) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude, longitude: wreck.longitude)) {
                Circle()
                    .foregroundStyle(Color.red)
                    .scaleEffect(0.5)
//                Image(systemName: "signpost.and.arrowtriangle.up.circle.fill")
//                    .font(.caption2)
//                    .onTapGesture {
//                        viewModel.selectedWreck = wreck
//                    }
//                    .scaleEffect(viewModel.selectedWreck == wreck ? 1.5 : 1)
            }
        }
        .onChange(of: appData.wrecks, perform: { wrecks in
            viewModel.minimumDateOfLossDate(forWrecks: wrecks)
            print(appData.wrecks)
        })
    }
    
    private var overlay: some View {
        VStack {
            MapPanelView(viewModel: viewModel)
            Spacer()
            if let selectedWreck = viewModel.selectedWreck {
                MapSelectedWreck(viewModel: viewModel, wreck: selectedWreck)
            }
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
