//
//  CollectionsViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

class CollectionsViewModel: ObservableObject {
    
    // Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func fetchCollections() async -> [Collection]? {
        do {
            return try await CollectionManager.shared.fetchCollections()
        } catch let error {
            showError(withMessage: "Error while loading collections from the server: \(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(collection: Collection) async -> Bool {
        do {
            try await CollectionManager.shared.delete(collection: collection)
            return true
        } catch let error {
            showError(withMessage: "Unable to delete collection: \(error.localizedDescription)")
            return false
        }
    }
}
