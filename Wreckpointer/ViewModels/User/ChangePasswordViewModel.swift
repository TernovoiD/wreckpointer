//
//  ChangePasswordViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordConfirmation: String = ""
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    var validForm: Bool {
        if oldPassword.isEmpty || newPassword.isEmpty || newPasswordConfirmation.isEmpty {
            showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !newPassword.isValidPassword || !newPasswordConfirmation.isValidPassword {
            showError(withMessage: "New password must contain at least 6 characters.")
            return false
        } else {
            return true
        }
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func changePassword() async {
        do {
            try await UserManager.shared.changePassword(userPassword: oldPassword, newPassword: newPassword, newPasswordConfirm: newPasswordConfirmation)
        } catch let error {
            showError(withMessage: "Password change failed: \(error.localizedDescription)")
            self.error = true
        }
    }
}
