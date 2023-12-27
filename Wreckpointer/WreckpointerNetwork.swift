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
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    let manager = WrecksManager()
}


// MARK: - Functions

extension WreckpointerNetwork {
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
    
    func loadWrecksFromServer() async {
        do {
            wrecks = try await manager.fetch()
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
    
    func add(wreck: Wreck) async {
        do {
            let newWreck = try await manager.create(wreck: wreck)
            wrecks.append(newWreck)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
