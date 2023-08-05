//
//  User.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var updatedAt: Date?
    var createdAt: Date?
    var email: String?
    var password: String?
    var confirmPassword: String?
    var newPassword: String?
    var newPasswordConfirm: String?
    
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
