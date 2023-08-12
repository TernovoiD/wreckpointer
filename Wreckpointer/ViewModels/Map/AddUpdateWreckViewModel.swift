//
//  AddUpdateWreckViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//

import Foundation

class AddUpdateWreckViewModel: ObservableObject {
    
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func create(wreck: Wreck) async -> Wreck? {
        do {
            return try await WreckManager.shared.create(wreck: wreck)
        } catch let error {
            showError(withMessage: "Unnable to create wreck: \(error.localizedDescription)")
            return nil
        }
    }
    
    func update(wreck: Wreck) async -> Wreck? {
        do {
            return try await WreckManager.shared.update(wreck: wreck)
        } catch let error {
            showError(withMessage: "Unnable to update wreck: \(error.localizedDescription)")
            return nil
        }
    }
}
