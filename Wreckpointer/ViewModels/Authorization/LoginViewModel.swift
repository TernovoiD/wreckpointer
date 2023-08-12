//
//  LoginViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    
    var validForm: Bool {
        if email.isEmpty || password.isEmpty {
            showError(withMessage: "Fields cannot be empty.")
            return false
        } else if !email.isValidEmail {
            showError(withMessage: "Email is not valid.")
            return false
        } else if !password.isValidPassword {
            showError(withMessage: "Password must contain at least 6 characters.")
            return false
        } else {
            return true
        }
    }
    
    func login() async {
        if validForm {
            do {
                try await UserManager.shared.signIn(withLogin: email, andPassword: password)
                clearForm()
            } catch let error {
                showError(withMessage: "Authorization failed: \(error.localizedDescription)")
            }
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
            self.email = ""
            self.password = ""
        }
    }
}
