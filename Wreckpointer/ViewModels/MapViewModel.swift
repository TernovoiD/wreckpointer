//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    @Published var mapWrecks: [Wreck] = []
    @Published var filteredWrecks: [Wreck] = []
    @Published var mapSelectedWreck: Wreck?
    
    // Map Overlay
    @Published var openMenu: Bool = false
    @Published var openFilter: Bool = false
    @Published var openSettings: Bool = false
    
    // Map settings
    @Published var mapScale: mapScales = .large
    @AppStorage("saveWrecks") var saveWrecks: Bool = true
    
    func mapSpan() -> Double {
        switch mapScale {
        case .small:
            return 0.33
        case .middle:
            return 1
        case .large:
            return 2
        }
    }
    
    // Interface
    @Published var showLoginView: Bool = false
    @Published var showAddWreckView: Bool = false
    @Published var showCollectionsView: Bool = false
    
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
    }
}


// MARK: - Filter

extension MapViewModel {
    
    func wrecksFilterdBySearch() -> [Wreck] {
        var filteredWrecks = mapWrecks
        
        if !textToSearch.isEmpty {
            let text: String = textToSearch.lowercased()
            filteredWrecks = filteredWrecks.filter({ $0.title.lowercased().contains(text)})
        }
        if !Calendar.current.isDate(minimumDate, equalTo: minimumDateOfLossDate(), toGranularity: .second) {
            filteredWrecks = filteredWrecks.filter({
                if let dateOfLoss = $0.dateOfLoss {
                    return dateOfLoss >= minimumDate
                } else {
                    return false
                }
            })
        }
        if !Calendar.current.isDate(maximumDate, equalTo: maximumDateOfLossDate(), toGranularity: .second) {
            filteredWrecks = filteredWrecks.filter({
                if let dateOfLoss = $0.dateOfLoss {
                    return dateOfLoss <= maximumDate
                } else {
                    return false
                }
            })
        }
        if showWreckDivesOnly {
            filteredWrecks = filteredWrecks.filter({ $0.wreckDive })
        }
        if wreckType != .all {
            filteredWrecks = filteredWrecks.filter({ $0.type == wreckType.rawValue })
        }
        return filteredWrecks
    }
    
    func minimumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        let wrecks = mapWrecks.filter({ $0.dateOfLoss != nil })
        
        if wrecks.isEmpty {
            return minimumDate
        } else {
            for wreck in mapWrecks {
                datesArray.append(wreck.dateOfLoss ?? Date())
            }
            return datesArray.min() ?? minimumDate
        }
    }
    
    func maximumDateOfLossDate() -> Date {
        var datesArray: [Date] = [ ]
        let wrecks = mapWrecks.filter({ $0.dateOfLoss != nil })
        
        if wrecks.isEmpty {
            return maximumDate
        } else {
            for wreck in mapWrecks {
                datesArray.append(wreck.dateOfLoss ?? Date())
            }
            return datesArray.min() ?? maximumDate
        }
    }
}


// MARK: - Update map

extension MapViewModel {
    
    func create(_ wreck: Wreck) async throws {
        let createdWreck = try await wrecksService.createWreck(wreck)
        if saveWrecks {
            try coreDataService.addWreck(createdWreck)
        }
        mapWrecks.append(createdWreck)
    }
    
    func update(_ wreck: Wreck) async throws {
        let updatedWreck = try await wrecksService.updateWreck(wreck)
        if saveWrecks {
            try coreDataService.addWreck(updatedWreck)
        }
        if let index = mapWrecks.firstIndex(where: { $0.id == updatedWreck.id }) {
            mapWrecks.remove(at: index)
            mapWrecks.append(updatedWreck)
        }
    }
    
    func delete(_ wreck: Wreck) async throws {
        try await wrecksService.deleteWreck(wreck)
        try coreDataService.deleteWreck(wreck: wreck)
        if let index = mapWrecks.firstIndex(where: { $0.id == wreck.id }) {
            mapWrecks.remove(at: index)
        }
    }
    
    func loadWrecksFromServer() async throws {
        let loadedWrecks = try await wreckLoader.downloadWrecksFromServer()
        if saveWrecks {
            try coreDataService.deleteWrecks()
            try coreDataService.addWrecks(loadedWrecks)
        }
        updateMap(withWrecks: loadedWrecks)
    }
    
    func loadWrecksFromCoreData() throws {
        let loadedWrecks = try coreDataService.fetchWrecks()
        updateMap(withWrecks: loadedWrecks)
    }
    
    func updateMap(withWrecks wrecks: [Wreck]) {
        DispatchQueue.main.async {
            self.mapWrecks = wrecks
            self.minimumDate = self.minimumDateOfLossDate()
            self.maximumDate = self.maximumDateOfLossDate()
        }
    }
    
    func deleteWrecksFromMemory() throws {
        try coreDataService.deleteWrecks()
    }
}
