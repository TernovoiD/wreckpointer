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
            return try await UserManager.shared.update(user: user)
        } catch let error {
            showError(withMessage: "Unable to update user info: \(error.localizedDescription)")
            self.error = true
            return nil
        }
    }
}
