//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

class MapViewModel: ObservableObject {
    
    @Published var mapWrecks: [Wreck] = []
    
    let wreckService: WreckService
    let coreDataService: CoreDataService
    
    init(wreckService: WreckService, coreDataService: CoreDataService) {
        self.wreckService = wreckService
        self.coreDataService = coreDataService
        downloadWrecks()
    }
    
    @Published var mapSelectedWreck: Wreck? {
        didSet {
            updateMapRegion()
        }
    }
    
    @Published var mapDetailedWreckView: Wreck?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.5, longitude: 0),
                                                                      span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    @Published var mapSpan: Double = 50
    
    private func updateMapRegion() {
        guard let location = mapSelectedWreck else { return }
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: mapSpan, longitudeDelta: mapSpan))
    }
    
    private func downloadWrecks() {
        Task {
            do {
                let (coreDataWrecks, lastUpdateTime) = try coreDataService.fetchWrecks()
                if coreDataWrecks.isEmpty {
                    let loadedWrecks = try await wreckService.downloadWrecksFromServer()
                    DispatchQueue.main.async {
                        self.mapWrecks = loadedWrecks
                    }
                    try coreDataService.addWrecks(loadedWrecks)
                } else {
                    DispatchQueue.main.async {
                        self.mapWrecks = coreDataWrecks
                    }
                    updateWrecks(fromDate: lastUpdateTime)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateWrecks(fromDate lastUpdate: Date) {
        Task {
            do {
                let updatedWrecks = try await wreckService.requestUpdatedWrecks(fromDate: lastUpdate)
                try coreDataService.addWrecks(updatedWrecks)
                let (coreDataWrecks, _) = try coreDataService.fetchWrecks()
                DispatchQueue.main.async {
                    self.mapWrecks = coreDataWrecks
                }
            } catch let error {
                print(error)
            }
        }
    }
}
