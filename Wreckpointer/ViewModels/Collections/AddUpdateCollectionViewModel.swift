//
//  AddUpdateCollectionViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class AddUpdateCollectionViewModel: ObservableObject {
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func create(collection: Collection) async -> Collection? {
        do {
            return try await CollectionManager.shared.create(collection: collection)
        } catch let error {
            showError(withMessage: "Failed: \(error.localizedDescription)")
            self.error = true
            return nil
        }
    }
    
    func update(collection: Collection) async -> Collection? {
        do {
            return try await CollectionManager.shared.update(collection: collection)
        } catch let error {
            showError(withMessage: "Failed: \(error.localizedDescription)")
            return nil
        }
        
    }
}
