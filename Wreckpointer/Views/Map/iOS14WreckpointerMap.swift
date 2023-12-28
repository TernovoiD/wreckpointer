//
//  iOS14WreckpointerMap.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 25.12.2023.
//

import SwiftUI
import MapKit

struct iOS14WreckpointerMap: View {
    
    @Binding var wrecks: [Wreck]
    @Binding var selectedWreck: Wreck?
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30,
                                                                             longitude: -75),
                                              span: MKCoordinateSpan(latitudeDelta: 80,
                                                                     longitudeDelta: 120))
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: wrecks) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude, longitude: wreck.longitude)) {
                Circle()
//                    .foregroundStyle(Color.red)
                    .scaleEffect(0.5)
            }
        }
        .onChange(of: selectedWreck, perform: { newSelectedWreck in
            if let wreck = newSelectedWreck {
                moveMap(to: wreck)
            }
        })
    }
    
    private func moveMap(to wreck: Wreck) {
        withAnimation(.easeInOut) {
            mapRegion.center = CLLocationCoordinate2D(latitude: wreck.latitude, 
                                                      longitude: wreck.longitude)
            if abs(wreck.latitude) > 65 {
                mapRegion.span = MKCoordinateSpan(latitudeDelta: 25,
                                                  longitudeDelta: 25)
            }
        }
    }
}

#Preview {
    iOS14WreckpointerMap(wrecks: .constant([]), selectedWreck: .constant(nil))
        .ignoresSafeArea()
}
