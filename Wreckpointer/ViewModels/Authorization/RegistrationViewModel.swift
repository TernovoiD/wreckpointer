//
//  RegistrationViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    func register(user: User) async -> User? {
        do {
            try await UserManager.shared.register(user: user)
            return try await UserManager.shared.fetchUser()
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
