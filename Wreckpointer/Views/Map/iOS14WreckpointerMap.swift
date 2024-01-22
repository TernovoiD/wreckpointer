//
//  iOS14WreckpointerMap.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 25.12.2023.
//

import SwiftUI
import MapKit

struct iOS14WreckpointerMap: View {
    
    @ObservedObject var map: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: map.region, annotationItems: map.filteredWrecks) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.hasCoordinates.latitude, longitude: wreck.hasCoordinates.longitude)) {
                
                if wreck == map.selectedWreck {
                    MapPin(wreck: wreck)
                } else {
                    Image(systemName: "diamond.inset.filled")
                        .foregroundStyle(Color.red)
                        .scaleEffect(0.5)
                        .onTapGesture {
                            withAnimation(.spring) {
                                map.selectedWreck = wreck
                            }
                        }
                }
            }
        }
        .onChange(of: map.selectedWreck, perform: { newSelectedWreck in
            if let wreck = newSelectedWreck {
                moveMap(to: wreck)
            }
        })
    }
    
    private func moveMap(to wreck: Wreck) {
        withAnimation(.easeInOut) {
            map.updateMapPosition(latitude: wreck.hasCoordinates.latitude, longitude: wreck.hasCoordinates.longitude)
            map.flag.toggle()
        }
    }
}

#Preview {
    iOS14WreckpointerMap(map: MapViewModel())
        .ignoresSafeArea()
}
