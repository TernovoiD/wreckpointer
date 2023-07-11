//
//  Wreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct Wreck {
    
    var id: UUID?
    var cause: WreckCausesEnum
    var type: WreckTypesEnum
    var title: String
    var image: String?
    var depth: Int?
    var approved: Bool?
    var latitude: Double
    var longitude: Double
    var wreckDive: Bool
    var dateOfLoss: Date?
    var information: String?
    var createdAt: Date?
    var updatedAt: Date?
    var moderators: [User]
}

extension Wreck: Equatable {
    static func == (lhs: Wreck, rhs: Wreck) -> Bool {
        lhs.id == rhs.id
    }
}
