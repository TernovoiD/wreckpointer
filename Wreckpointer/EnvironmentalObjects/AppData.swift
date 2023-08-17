//
//  AppData.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

@MainActor
class AppData: ObservableObject {
    @Published var wrecks: [Wreck] = [ ]
    @Published var collections: [Collection] = [ ]
    
    @Published var coreData: CoreDataState = .loading
    @Published var serverData: ServerState = .loading
    @Published var collectionsData: CollectionsState = .loading
    
    // Filter options
    @Published var textToSearch: String = ""
    @Published var filterByDate: Bool = false
    @Published var filterByType: Bool = false
    @Published var filterByCause: Bool = false
    @Published var showWreckDivesOnly: Bool = false
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var wreckType: WreckTypesEnum = .unknown
    @Published var wreckCause: WreckCausesEnum = .unknown
    
    func loadWrecksFromServer() async {
        serverData = .loading
        do {
            wrecks = try await WreckManager.shared.fetchWrecks()
            serverData = .ready
        } catch {
            serverData = .error
        }
    }
    
    func loadWrecksFromCoreData() {
        coreData = .loading
        do {
            wrecks = try CDManager.shared.fetchWrecks()
            coreData = .uploaded
        } catch {
            coreData = .error
        }
    }
    
    func loadCollections() async {
        collectionsData = .loading
        do {
            collections = try await CollectionManager.shared.fetchCollections()
            collectionsData = .upToDate
        } catch {
            collectionsData = .serverError
        }
    }
}


// MARK: - Filter

extension AppData {
    
    var wrecksFiltered: [Wreck] {
        var filteredWrecks = wrecks
        if !textToSearch.isEmpty {
            filteredWrecks = filteredWrecks.filter({ $0.title.lowercased().contains(textToSearch.lowercased()) })
        }
        if filterByDate {
            filteredWrecks = filteredWrecks.filter({
                if let dateOfLoss = $0.dateOfLoss {
                    return dateOfLoss >= minimumDate && dateOfLoss <= maximumDate
                } else {
                    return false
                }
            })
        }
        if filterByCause {
            filteredWrecks = filteredWrecks.filter({ $0.cause == wreckCause.rawValue })
        }
        if filterByType {
            filteredWrecks = filteredWrecks.filter({ $0.type == wreckType.rawValue })
        }
        if showWreckDivesOnly {
            filteredWrecks = filteredWrecks.filter({ $0.wreckDive })
        }
        return filteredWrecks
    }
}


// MARK: - Enums

extension AppData {
    
    enum ServerState {
        case loading
        case ready
        case error
    }
    
    enum CollectionsState {
        case loading
        case upToDate
        case serverError
    }
    
    enum CoreDataState {
        case loading
        case uploaded
        case error
    }
}
    
