//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

@MainActor
class MapViewModel: ObservableObject {
    
    @Published var mapRegion: MKCoordinateRegion
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        let mapCoordinateCenter = CLLocationCoordinate2D(latitude: 40, longitude: -30)
        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80)
        let mapCoordinateRegion = MKCoordinateRegion(center: mapCoordinateCenter, span: mapCoordinateSpan)
        self.mapRegion = mapCoordinateRegion
    }
    
    func changeMapRegion(latitude: Double, longitude: Double) {
        mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if abs(latitude) > 70 {
            mapRegion.span = MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
        }
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
