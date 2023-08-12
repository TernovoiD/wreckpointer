//
//  User.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct User: Codable, Equatable {
    var id: UUID?
    var image: Data?
    var username: String?
    var updatedAt: Date?
    var createdAt: Date?
    var email: String?
    var bio: String?
    var password: String?
    var confirmPassword: String?
    var newPassword: String?
    var newPasswordConfirm: String?
    
    init(id: UUID? = nil,
         username: String? = nil,
         image: Data? = nil,
         updatedAt: Date? = nil,
         createdAt: Date? = nil,
         email: String? = nil,
         bio: String? = nil,
         password: String? = nil,
         confirmPassword: String? = nil,
         newPassword: String? = nil,
         newPasswordConfirm: String? = nil) {
        self.id = id
        self.username = username
        self.image = image
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.email = email
        self.bio = bio
        self.password = password
        self.confirmPassword = confirmPassword
        self.newPassword = newPassword
        self.newPasswordConfirm = newPasswordConfirm
    }
    
    init() {
        self.id = nil
        self.username = nil
        self.image = nil
        self.updatedAt = nil
        self.createdAt = nil
        self.email = nil
        self.bio = nil
        self.password = nil
        self.confirmPassword = nil
        self.newPassword = nil
        self.newPasswordConfirm = nil
    }
    
    static let test = User(id: UUID(uuidString: "09839045"),
                           username: "Antonio",
                           image: nil,
                           updatedAt: Date(),
                           createdAt: Date(),
                           email: "testemail@gmail.com",
                           bio: "Holloway attacks by firing a Very pistol into the alien's single eye, temporarily blinding it. While the eye rapidly heals, Holloway races back to Lungfish and returns to the Tigershark. When Dr. Neilson asks about the remainder of their boarding party, Holloway says.",
                           password: nil,
                           confirmPassword: nil,
                           newPassword: nil,
                           newPasswordConfirm: nil)
    
}
