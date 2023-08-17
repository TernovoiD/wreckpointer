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
    
    func validForm(title: String, latitude: String, longitude: String, depth: String) -> Bool {
        if !title.isValidWreckName {
            showError(withMessage: "The name must include at least 3 symbols.")
            return false
        } else if !latitude.isValidLatitude {
            showError(withMessage: "Latitude error! Latitude ranges between 0 and 90 degrees (North or South).")
            return false
        } else if !longitude.isValidLongitude {
            showError(withMessage: "Longitude error! Latitude ranges between 0 and 180 degrees (West or East).")
            return false
        } else if !depth.isValidDepth {
            showError(withMessage: "Depth is incorrect.")
            return false
        } else {
            return true
        }
    }
    
    func create(wreck: Wreck) async -> Wreck? {
        do {
            return try await WreckManager.shared.create(wreck: wreck)
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
    
    func update(wreck: Wreck) async -> Wreck? {
        do {
            let createdWreck = try await WreckManager.shared.update(wreck: wreck)
            try CDManager.shared.save(wreck: createdWreck)
            return createdWreck
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
}
