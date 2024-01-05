//
//  WreckpointerNetwork.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

@MainActor
final class WreckpointerNetwork: ObservableObject {
    //Data
    @Published var databaseWrecks: [Wreck] = [ ]
    @Published var todayWrecks: [Wreck] = [ ]
    @Published var lastApprovedWrecks: [Wreck] = [ ]
    @Published var randomWrecks: [Wreck] = [ ]
    @Published var modernWrecks: [Wreck] = [ ]
    @Published var user: User?
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    let authManager = AuthManager()
    let wrecksManager = WrecksManager()
    
    // Filter options
    @Published var textToSearch: String = ""
    @Published var filterByDate: Bool = false
    @Published var minimumDateFilter: Date = Date()
    @Published var maximumDateFilter: Date = Date()
    @Published var wreckTypeFilter: WreckTypes?
    @Published var wreckCauseFilter: WreckCauses?
    @Published var wreckDiverOnlyFilter: Bool = false
    
    var searchedWrecks: [Wreck] {
        if textToSearch.isEmpty {
            return databaseWrecks
        } else {
            return databaseWrecks.filter({ $0.hasName.lowercased().contains(textToSearch.lowercased())})
        }
    }
    
    var filteredWrecks: [Wreck] {
        var filteredWrecks = databaseWrecks
        
        if filterByDate {
            filteredWrecks = filteredWrecks.filter({
                $0.hasDateOfLoss.isValid
            })
            filteredWrecks = filteredWrecks.filter({
                $0.hasDateOfLoss.date >= minimumDateFilter && $0.hasDateOfLoss.date <= maximumDateFilter
            })
        }
        if wreckTypeFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasType == wreckTypeFilter })
        }
        if wreckCauseFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasCause == wreckCauseFilter })
        }
        if wreckDiverOnlyFilter {
            filteredWrecks = filteredWrecks.filter({ $0.isWreckDive == true })
        }
        return filteredWrecks
    }
    
    init() {
        Task {
//            await authorize()
            await loadServerInfo()
        }
    }
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
}


// MARK: - Auth

extension WreckpointerNetwork {
    
    func login(username: String, password: String) async {
        do {
            try await authManager.authorize(login: username, password: password)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func authorize() async {
        do {
            let authorizedUser = try await authManager.checkAuthorizationStatus()
            self.user = authorizedUser
        } catch {
            self.user = nil
        }
    }
}


// MARK: - Wrecks

extension WreckpointerNetwork {
    
    func loadServerInfo() async {
        do {
            let serverInfo = try await wrecksManager.loadServerInfo()
            databaseWrecks = serverInfo.databaseWrecks
            todayWrecks = serverInfo.todayWrecks
            lastApprovedWrecks = serverInfo.lastApprovedWrecks
            randomWrecks = serverInfo.randomWrecks
            modernWrecks = serverInfo.modernHistoryWrecks
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func loadWreck(_ wreck: Wreck) async -> Wreck? {
        do {
            let loadedWreck = try await wrecksManager.fetch(wreckID: wreck.id)
            return loadedWreck
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
    
    func createWreck(_ wreck: Wreck) async {
        do {
            try await wrecksManager.create(wreck: wreck)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func updateWreck(_ wreck: Wreck) async {
        do {
            try await wrecksManager.update(wreck: wreck)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func deleteWreck(_ wreck: Wreck) async {
        do {
            try await wrecksManager.delete(wreck: wreck)
            databaseWrecks.removeAll(where: { $0.id == wreck.id })
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
