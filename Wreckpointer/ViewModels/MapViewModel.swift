//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

class MapViewModel: ObservableObject {
    
    @Published var showMap: Bool = false
    
    @Published var mapWrecks: [Wreck] = [] {
        didSet {
            mapSelectedWreck = mapWrecks.first
        }
    }
    
    @Published var mapSelectedWreck: Wreck? {
        didSet {
            updateMapRegion()
        }
    }
    
    @Published var mapDetailedWreckView: Wreck?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 0),
                                                                      span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    @Published var mapSpan: Double = 50
    
    
    // MARK: Map functions
    
    func nextWreck() {
        guard let currentIndex = mapWrecks.firstIndex(where: { $0 == mapSelectedWreck }) else { return }
        let nextIndex = currentIndex + 1
        
        if mapWrecks.indices.contains(nextIndex) {
            let nextWreck = mapWrecks[nextIndex]
            mapSelectedWreck = nextWreck
        } else {
            guard let nextWreck = mapWrecks.first else { return }
            mapSelectedWreck = nextWreck
            return
        }
    }
    
    private func updateMapRegion() {
        guard let location = mapSelectedWreck else { return }
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: mapSpan, longitudeDelta: mapSpan))
    }
}
