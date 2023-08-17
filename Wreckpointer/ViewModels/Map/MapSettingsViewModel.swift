//
//  MapSettingsViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

class MapSettingsViewModel: ObservableObject {
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func saveInMemory(wrecks: [Wreck]) {
        do {
            try CDManager.shared.deleteAll()
            for wreck in wrecks {
                try CDManager.shared.save(wreck: wreck)
            }
        } catch let error {
            showError(withMessage: "Error: \(error.localizedDescription)")
        }
    }
    
    func deleteWrecksFromMemory() {
        do {
            try CDManager.shared.deleteAll()
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
