//
//  AuthenticationViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    
    @Published var user: User?
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
        authenticateUser()
    }
    
    func createAccount(forUser user: User) async throws {
        try await userService.register(user: user)
        authenticateUser()
    }
    
    func deleteAccount() async throws {
        if let user {
            try await userService.deleteAccount(forUser: user)
        }
        authenticateUser()
    }
    
    func logIn(email: String, password: String) async throws {
        try await userService.signIn(withLogin: email, andPassword: password)
        authenticateUser()
    }
    
    func signOut() {
        userService.signOut()
        user = nil
    }
    
    func changeAccountPassword(password: String, newPassword: String, newPasswordConfirmation: String) async throws {
        try await userService.changePassword(userPassword: password, newPassword: newPassword, newPasswordConfirm: newPasswordConfirmation)
    }
    
    func requestPasswordReset(forEmail email: String) async throws {
        try await userService.resetPassword(onEmail: email)
    }
    
    private func authenticateUser() {
        Task {
            do {
                let authenticatedUser = try await userService.fetchUser()
                DispatchQueue.main.async {
                    self.user = authenticatedUser
                }
            } catch let error {
                print(error)
            }
        }
    }
}
