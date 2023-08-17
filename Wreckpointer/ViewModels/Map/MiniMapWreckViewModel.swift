//
//  MiniMapWreckViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.08.2023.
//

import Foundation
import MapKit

class MiniMapWreckViewModel: ObservableObject {
    
    @Published var mapRegion: MKCoordinateRegion
    @Published var mapSpan: CLLocationDegrees = 15
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        let mapCoordinateCenter = CLLocationCoordinate2D(latitude: 30.5, longitude: 0)
        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        let mapCoordinateRegion = MKCoordinateRegion(center: mapCoordinateCenter, span: mapCoordinateSpan)
        self.mapRegion = mapCoordinateRegion
    }
    
    func changeMapRegion(latitude: Double, longitude: Double) {
        mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func adjustMapSpan() {
        mapRegion.span = MKCoordinateSpan(latitudeDelta: mapSpan, longitudeDelta: mapSpan)
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
