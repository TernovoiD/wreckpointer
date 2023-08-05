//
//  Collection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

struct Collection: Codable, Identifiable {
    var id: UUID?
    var title: String
    var description: String?
    var image: Data?
    var createdAt: Date?
    var updatedAt: Date?
    var blocks: [Block]
    var approved: Bool
    
    init(id: UUID? = nil, title: String, description: String? = nil, image: Data? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, blocks: [Block], approved: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.blocks = blocks
        self.approved = approved
    }
}
