//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

class MapViewModel: ObservableObject {
    
    @Published var mapWrecks: [Wreck] = []
    
    // Interface
    @Published var openMenu: Bool = false
    @Published var openFilter: Bool = false
    @Published var showLoginView: Bool = false
    
    // Filter
    @Published var searchIsActive: Bool = false
    @Published var textToSearch: String = ""
    @Published var showWreckDivesOnly: Bool = false
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var wreckType: WreckTypesEnum = .all
    
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
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.5,
                                                                                                     longitude: 0),
                                                                      span: MKCoordinateSpan(latitudeDelta: 50,
                                                                                             longitudeDelta: 50))
    @Published var mapSpan: Double = 50
    
    private func updateMapRegion() {
        guard let location = mapSelectedWreck else { return }
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude,
                                                                      longitude: location.longitude),
                                       span: MKCoordinateSpan(latitudeDelta: mapSpan,
                                                              longitudeDelta: mapSpan))
    }
    
}


// MARK: - Filter

extension MapViewModel {
    
    func wrecksFilterdBySearch() -> [Wreck] {
        var filteredWrecks = mapWrecks
        
        if showWreckDivesOnly {
            filteredWrecks = filteredWrecks.filter({ $0.wreckDive })
        }
        if !textToSearch.isEmpty {
            let text: String = textToSearch.lowercased()
            filteredWrecks = filteredWrecks.filter({ $0.title.lowercased().contains(text)})
        }
        return filteredWrecks
    }
    
    func minimumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        for wreck in mapWrecks {
            datesArray.append(wreck.dateOfLoss ?? Date())
        }
        print(datesArray)
        return datesArray.min() ?? Date()
    }
    
    func maximumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        for wreck in mapWrecks {
            if let date = wreck.dateOfLoss {
                datesArray.append(date)
            }
        }
        print(datesArray)
        return datesArray.max() ?? Date()
    }
}


// MARK: - Update map

extension MapViewModel {
    
    private func downloadWrecks() {
        Task {
            do {
                let (coreDataWrecks, lastUpdateTime) = try coreDataService.fetchWrecks()
                if coreDataWrecks.isEmpty {
                    let loadedWrecks = try await wreckService.downloadWrecksFromServer()
                    DispatchQueue.main.async {
                        self.mapWrecks = loadedWrecks
                        self.minimumDate = self.minimumDateOfLossDate()
                        self.maximumDate = self.maximumDateOfLossDate()
                    }
                    try coreDataService.addWrecks(loadedWrecks)
                } else {
                    DispatchQueue.main.async {
                        self.mapWrecks = coreDataWrecks
                        self.minimumDate = self.minimumDateOfLossDate()
                        self.maximumDate = self.maximumDateOfLossDate()
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
                    self.minimumDate = self.minimumDateOfLossDate()
                    self.maximumDate = self.maximumDateOfLossDate()
                }
            } catch let error {
                print(error)
            }
        }
    }
}
