//
//  SelectedWreckViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class SelectedWreckViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func delete(wreck: Wreck) async -> Bool {
        do {
            try await WreckManager.shared.delete(wreck: wreck)
            return true
        } catch let error {
            showError(withMessage: "Unable to delete wreck: \(error.localizedDescription)")
            self.error = true
            return false
        }
    }
}
