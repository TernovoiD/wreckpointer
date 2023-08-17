//
//  AccountViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class AccountViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func signOut() {
        UserManager.shared.signOut()
    }
    
    func deleteAccount(forUser user: User) async -> Bool {
        do {
            try await UserManager.shared.deleteAccount(forUser: user)
            return true
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return false
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return false
        }
    }
}
