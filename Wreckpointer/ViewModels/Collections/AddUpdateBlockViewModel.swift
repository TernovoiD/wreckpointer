//
//  AddUpdateBlockViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class AddUpdateBlockViewModel: ObservableObject {
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func create(block: Block, inCollection collection: Collection) async -> Block? {
        do {
            return try await CollectionManager.shared.addBlock(block, toCollection: collection)
        } catch let error {
            showError(withMessage: "Failed: \(error.localizedDescription)")
            self.error = true
            return nil
        }
    }
    
    func update(block: Block, inCollection collection: Collection) async -> Block? {
        do {
            return try await CollectionManager.shared.updateBlock(block, inCollection: collection)
        } catch let error {
            showError(withMessage: "Failed: \(error.localizedDescription)")
            return nil
        }
    }
}
