//
//  MapView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        ZStack {
            map
            VStack {
                HStack {
                    goBackButton
                        .offset(y: mapVM.showMap ? 0 : -1000)
                    Spacer()
                    if mapVM.mapSelectedWreck != nil {
                        closeWreckButton
                    }
                }
                Spacer()
                ForEach(mapVM.mapWrecks) { wreck in
                    if wreck == mapVM.mapSelectedWreck {
                        SelectedWreckPanel(wreck: wreck)
                    }
                }
                .offset(y: mapVM.showMap ? 0 : 1000)
            }
        }
        .sheet(item: $mapVM.mapDetailedWreckView) { wreck in
            WreckDetailedView(wreck: wreck)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
    }
}

// MARK: Content

extension MapView {
    
    var map: some View {
        Map(coordinateRegion: $mapVM.mapRegion, annotationItems: mapVM.mapWrecks) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                MapPinView(wreck: wreck)
                    .scaleEffect(mapVM.mapSelectedWreck == wreck ? 1 : 0.7)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: Buttons

extension MapView {
    
    var goBackButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.showMap = false
            }
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding()
        }
    }
    
    var closeWreckButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.mapSelectedWreck = nil
            }
        } label: {
            HStack {
                Image(systemName: "xmark")
                Text("Close wreck")
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding()
        }
    }
}
