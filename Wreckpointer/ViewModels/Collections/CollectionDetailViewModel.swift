//
//  CollectionDetailViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

class CollectionDetailViewModel: ObservableObject {
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func delete(block: Block, collectionID: UUID?) async -> Bool {
        do {
            try await CollectionManager.shared.removeBlock(block, fromCollectionWithID: collectionID)
            return true
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return false
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return false
        }
    }
}
