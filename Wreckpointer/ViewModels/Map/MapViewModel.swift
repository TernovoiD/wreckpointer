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
        let mapCoordinateCenter = CLLocationCoordinate2D(latitude: 30.5, longitude: 0)
        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        let mapCoordinateRegion = MKCoordinateRegion(center: mapCoordinateCenter, span: mapCoordinateSpan)
        self.mapRegion = mapCoordinateRegion
    }
    
    func changeMapRegion(latitude: Double, longitude: Double) {
        mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
