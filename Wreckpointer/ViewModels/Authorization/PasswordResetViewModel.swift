//
//  PasswordResetViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class PasswordResetViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    func resetPassword(onEmail email: String) async -> Bool {
        do {
            try await UserManager.shared.resetPassword(onEmail: email)
            return true
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return false
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return false
        }
    }
    
    func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
