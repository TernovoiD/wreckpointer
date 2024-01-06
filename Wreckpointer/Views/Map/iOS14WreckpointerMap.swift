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
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30,
                                                                                     longitude: -75),
                                                      span: MKCoordinateSpan(latitudeDelta: 80,
                                                                             longitudeDelta: 120))
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: map.filteredWrecks) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.hasCoordinates.latitude, longitude: wreck.hasCoordinates.longitude)) {
                
                if mapRegion.span.longitudeDelta < 30 {
                    MapPinMedium(wreck: wreck)
                        .onTapGesture {
                            withAnimation(.spring) {
                                map.selectedWreck = wreck
                            }
                        }
                } else {
                    Circle()
                        .foregroundStyle(Color.red)
                        .scaleEffect(0.5)
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
            mapRegion.center = CLLocationCoordinate2D(latitude: wreck.hasCoordinates.latitude,
                                                      longitude: wreck.hasCoordinates.longitude)
            if abs(wreck.hasCoordinates.latitude) > 65 {
                mapRegion.span = MKCoordinateSpan(latitudeDelta: 25,
                                                  longitudeDelta: 25)
            }
        }
    }
}

#Preview {
    iOS14WreckpointerMap(map: MapViewModel())
        .ignoresSafeArea()
}
