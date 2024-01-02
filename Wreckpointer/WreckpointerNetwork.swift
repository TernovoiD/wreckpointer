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
    @Published var wrecks: [Wreck] = [ ]
    @Published var user: User?
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    let authManager = AuthManager()
    let wrecksManager = WrecksManager()
    
    init() {
        Task {
//            await authorize()
//            await loadWrecks()
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
    
    func loadWrecks() async {
        do {
            wrecks = try await wrecksManager.fetchAll()
            print(wrecks)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
//    func loadWreck(_ wreck: Wreck) async -> Wreck {
//        do {
//            let loadedWreck = try await wrecksManager.fetch(wreckID: wreck.id)
//            return loadedWreck
//        } catch let error {
//            showError(withMessage: error.localizedDescription)
//        }
//    }
    
    func createWreck(_ wreck: Wreck) async {
        do {
            let newWreck = try await wrecksManager.create(wreck: wreck)
            wrecks.append(newWreck)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func updateWreck(_ wreck: Wreck) async {
        do {
            let updatedWreck = try await wrecksManager.update(wreck: wreck)
            wrecks.removeAll(where: { $0.id == updatedWreck.id })
            wrecks.append(updatedWreck)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func deleteWreck(_ wreck: Wreck) async {
        do {
            try await wrecksManager.delete(wreck: wreck)
            wrecks.removeAll(where: { $0.id == wreck.id })
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
