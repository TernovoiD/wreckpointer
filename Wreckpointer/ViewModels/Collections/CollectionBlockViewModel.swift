//
//  CollectionBlockViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class CollectionBlockViewModel: ObservableObject {
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func delete(block: Block, fromCollection collection: Collection) async -> Bool {
        do {
            try await CollectionManager.shared.removeBlock(block, fromCollection: collection)
            return true
        } catch let error {
            showError(withMessage: "Unable to delete collection block: \(error.localizedDescription)")
            return false
        }
    }
}
