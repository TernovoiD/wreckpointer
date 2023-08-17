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
    
    func create(block: Block, collectionID: UUID?) async -> Block? {
        do {
            return try await CollectionManager.shared.addBlock(block, toCollectionWithID: collectionID)
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
    
    func update(block: Block, collectionID: UUID?) async -> Block? {
        do {
            return try await CollectionManager.shared.updateBlock(block, inCollectionWithID: collectionID)
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
}
