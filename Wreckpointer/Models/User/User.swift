//
//  User.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID?
    let createdAt: Date?
    let updatedAt: Date?
    let username: String
    let role: UserRoles
    
    static let test = User(id: UUID(uuidString: "12345"), createdAt: Date(), updatedAt: Date(), username: "Moderator_1", role: .moderator)
}
