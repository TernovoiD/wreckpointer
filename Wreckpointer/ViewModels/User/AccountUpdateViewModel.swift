//
//  AccountUpdateViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import Foundation

class AccountUpdateViewModel: ObservableObject {
    
    // Errors handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    
    private func showError(withMessage message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.error = true
        }
    }
    
    func update(user: User) async -> User? {
        do {
            let updatedUser = try await UserManager.shared.update(user: user)
            return updatedUser
        } catch let httpError as HTTPError {
            showError(withMessage: httpError.errorDescription)
            return nil
        } catch let error {
            showError(withMessage: error.localizedDescription)
            return nil
        }
    }
}
