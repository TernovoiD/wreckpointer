//
//  LoginViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    func login(withEmail email: String, andPassword password: String) async -> User? {
        do {
            try await UserManager.shared.signIn(withLogin: email, andPassword: password)
            return try await UserManager.shared.fetchUser()
        } catch HTTPError.unauthorized {
            showError(withMessage: "Incorrect credentials. Try again.")
            return nil
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
    
    func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
}
