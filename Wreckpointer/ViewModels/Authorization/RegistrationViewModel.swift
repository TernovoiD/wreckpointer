//
//  RegistrationViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    var validForm: Bool {
        if email.isEmpty || username.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            showError(withMessage: "Email is not valid.")
            return false
        } else if !username.isValidName {
            showError(withMessage: "username must contain at least 5 characters.")
            return false
        } else if !password.isValidPassword {
            showError(withMessage: "Password must contain at least 8 characters.")
            return false
        } else if password != passwordConfirmation {
            showError(withMessage: "Passwords do not match! Try again")
            return false
        } else {
            return true
        }
    }
    
    func register() async -> Bool {
        do {
            let user = User(username: username, email: email, password: password, confirmPassword: passwordConfirmation)
            try await UserManager.shared.register(user: user)
            clearForm()
            return true
        } catch let error {
            showError(withMessage: "Authorization failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchUser() async -> User? {
        do {
            return try await UserManager.shared.fetchUser()
        } catch let error {
            showError(withMessage: "Authorization failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    private func clearForm() {
        DispatchQueue.main.async {
            self.username = ""
            self.email = ""
            self.password = ""
            self.passwordConfirmation = ""
        }
    }
}
