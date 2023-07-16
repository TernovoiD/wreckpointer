//
//  Wreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct Wreck: Codable, Identifiable {
    
    var id: UUID?
    var cause: String
    var type: String
    var title: String
    var image: Data?
    var depth: Double?
    var approved: Bool?
    var latitude: Double
    var longitude: Double
    var wreckDive: Bool
    var dateOfLoss: Date?
    var information: String?
    var createdAt: Date?
    var updatedAt: Date?
    var moderators: [User]?
}

extension Wreck: Equatable {
    static func == (lhs: Wreck, rhs: Wreck) -> Bool {
        lhs.id == rhs.id
    }
}
