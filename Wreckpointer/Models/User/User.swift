//
//  User.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID?
    let email: String
    let bio: String?
    let username: String?
    let role: UserRoles
    let createdAt: Date?
    let updatedAt: Date?
    
    init(id: UUID? = nil, email: String, bio: String? = nil, username: String? = nil, role: UserRoles, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.email = email
        self.bio = bio
        self.username = username
        self.role = role
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static let test = User(email: "moderator1", role: .moderator)
}
