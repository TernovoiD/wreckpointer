//
//  WreckpointerViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.12.2023.
//

import Foundation

final class WreckpointerViewModel: ObservableObject {
    
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    func loadWrecksFromServer() async -> [Wreck] {
        do {
            return try await WrecksManager.shared.fetchWrecks()
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return [ ]
        }
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
