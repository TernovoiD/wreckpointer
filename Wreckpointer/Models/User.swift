//
//  User.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct User: Codable {
    let id: String?
    let username: String?
    let updatedAt: Date?
    let createdAt: Date?
    let email: String?
    let password: String?
    let confirmPassword: String?
    let newPassword: String?
    let newPasswordConfirm: String?
    
    init(id: String? = nil,
         username: String? = nil,
         updatedAt: Date? = nil,
         createdAt: Date? = nil,
         email: String? = nil,
         password: String? = nil,
         confirmPassword: String? = nil,
         newPassword: String? = nil,
         newPasswordConfirm: String? = nil) {
        self.id = id
        self.username = username
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.newPassword = newPassword
        self.newPasswordConfirm = newPasswordConfirm
    }
    
}
