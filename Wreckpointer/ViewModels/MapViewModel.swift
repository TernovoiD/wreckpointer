//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

class MapViewModel: ObservableObject {
    
    @Published var mapWrecks: [Wreck] = []
    @Published var mapSelectedWreck: Wreck?
    
    // Map Overlay
    @Published var openMenu: Bool = false
    @Published var openFilter: Bool = false
    @Published var openSettings: Bool = false
    
    // Map settings
    @Published var mapScale: mapScales = .large
    
    func mapSpan() -> Double {
        switch mapScale {
        case .small:
            return 0.33
        case .middle:
            return 1.5
        case .large:
            return 3
        }
    }
    
    // Interface
    @Published var showLoginView: Bool = false
    @Published var showAddWreckView: Bool = false
    @Published var showStoriesView: Bool = false
    
    // Filter
    @Published var searchIsActive: Bool = false
    @Published var textToSearch: String = ""
    @Published var showWreckDivesOnly: Bool = false
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var wreckType: WreckTypesEnum = .all
    
    let wreckLoader: WrecksLoader
    let wrecksService: WrecksService
    let coreDataService: CoreDataService
    
    init(wreckLoader: WrecksLoader, wrecksService: WrecksService, coreDataService: CoreDataService) {
        self.wreckLoader = wreckLoader
        self.wrecksService = wrecksService
        self.coreDataService = coreDataService
        downloadWrecks()
        updateWrecks()
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
        if minimumDate != minimumDateOfLossDate() {
            filteredWrecks = filteredWrecks.filter({
                if let dateOfLoss = $0.dateOfLoss {
                    return dateOfLoss >= minimumDate
                } else {
                    return false
                }
            })
        }
        if maximumDate != maximumDateOfLossDate() {
            
        }
        return filteredWrecks
    }
    
    func minimumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        for wreck in mapWrecks {
            datesArray.append(wreck.dateOfLoss ?? Date())
        }
        return datesArray.min() ?? Date()
    }
    
    func maximumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        for wreck in mapWrecks {
            datesArray.append(wreck.dateOfLoss ?? Date())
        }
        return datesArray.max() ?? Date()
    }
}


// MARK: - Update map

extension MapViewModel {
    
    func create(_ wreck: Wreck) async throws {
        let createdWreck = try await wrecksService.createWreck(wreck)
        try coreDataService.addWreck(createdWreck)
        updateWrecks()
    }
    
    func update(_ wreck: Wreck) async throws {
        let updatedWreck = try await wrecksService.updateWreck(wreck)
        try coreDataService.addWreck(updatedWreck)
        updateWrecks()
    }
    
    func delete(_ wreck: Wreck) async throws {
        try await wrecksService.deleteWreck(wreck)
        try coreDataService.deleteWreck(wreck: wreck)
        updateWrecks()
    }
    
    private func downloadWrecks() {
        Task {
            do {
                let coreDataWrecks = try coreDataService.fetchWrecks()
                if coreDataWrecks.isEmpty {
                    let loadedWrecks = try await wreckLoader.downloadWrecksFromServer()
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
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func updateWrecks() {
        Task {
            do {
                let lastUpdateTime = try coreDataService.lastUpdateTime()
                let updatedWrecks = try await wreckLoader.requestUpdatedWrecks(fromDate: lastUpdateTime)
                try coreDataService.addWrecks(updatedWrecks)
                let coreDataWrecks = try coreDataService.fetchWrecks()
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
