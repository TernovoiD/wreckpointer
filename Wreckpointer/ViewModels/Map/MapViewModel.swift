//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

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
    
    func loadWrecksFromServer() async -> [Wreck]? {
        do {
            return try await WreckManager.shared.fetchWrecks()
        } catch let error {
            showError(withMessage: "Unable to load wrecks from the server: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadWrecksFromCoreData() -> [Wreck]? {
        do {
            return try CDManager.shared.fetchWrecks()
        } catch let error {
            showError(withMessage: "Unable to load wrecks from memory: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveInMemory(wrecks: [Wreck]) {
        do {
            for wreck in wrecks {
                try CDManager.shared.save(wreck: wreck)
            }
        } catch let error {
            showError(withMessage: "Unable to save wrecks from memory: \(error.localizedDescription)")
        }
    }
    
    func deleteWrecksFromMemory() {
        do {
            try CDManager.shared.deleteAll()
        } catch let error {
            showError(withMessage: "Unable to delete wrecks from memory: \(error.localizedDescription)")
        }
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
