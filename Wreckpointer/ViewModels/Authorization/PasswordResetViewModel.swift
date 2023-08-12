//
//  PasswordResetViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class PasswordResetViewModel: ObservableObject {
    
    @Published var email: String = ""
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    var validForm: Bool {
        if email.isEmpty {
            showError(withMessage: "Email field is empty!")
            return false
        } else if !email.isValidEmail {
            showError(withMessage: "Email is not valid.")
            return false
        } else {
            return true
        }
    }
    
    func reset() async {
        if validForm {
            do {
                try await UserManager.shared.resetPassword(onEmail: email)
                clearForm()
            } catch let error {
                showError(withMessage: "Unable to reset password: \(error.localizedDescription)")
            }
        }
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    private func clearForm() {
        email = ""
    }
}
