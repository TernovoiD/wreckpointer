//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI

@main
struct WreckpointerApp: App {
    
    @StateObject var state = AppState()
    @StateObject var wrecks = Wrecks()
    @StateObject var collections = Collections()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(state)
                .environmentObject(wrecks)
                .environmentObject(collections)
        }
    }
}


// MARK: - Environmental Objects

class Wrecks: ObservableObject {
    @Published var all: [Wreck] = [ ]
    @Published var selectedWreck: Wreck?
    
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
    
    var filteredByText: [Wreck] { return all.filter({ $0.title.lowercased().contains(textToSearch.lowercased()) }) }
    
    var filtered: [Wreck] {
        var filteredWrecks = all
        if !textToSearch.isEmpty {
            filteredWrecks = filteredWrecks.filter({ $0.title.lowercased().contains(textToSearch.lowercased()) })
        }
        if filterByDate {
            filteredWrecks = filteredWrecks.filter({
                if let dateOfLoss = $0.dateOfLoss {
                    return dateOfLoss >= minimumDate || dateOfLoss <= maximumDate
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

class Collections: ObservableObject {
    @Published var all: [Collection] = [ ]
    
    func updateCollection(_ collection: Collection) {
        var collectionsToUpdate = all
        collectionsToUpdate.removeAll(where: { $0.id == collection.id })
        collectionsToUpdate.append(collection)
        all = collectionsToUpdate
    }
}

class AppState: ObservableObject {
    @Published var activeUIElement: UIElements?
    @Published var authorizedUser: User?
    
    init() {
        Task {
            let user = await authorize()
            DispatchQueue.main.async {
                self.authorizedUser = user
            }
        }
    }
    
    func authorize() async -> User? {
        do {
            return try await UserManager.shared.fetchUser()
        } catch {
            return nil
        }
    }
    
    enum UIElements {
        case mapMenu
        case mapSettings
        case mapFilter
        case mapSearch
    }
}
