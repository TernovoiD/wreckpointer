//
//  Block.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

struct Block: Codable, Identifiable {
    var id: String?
    var title: String
    var number: Double?
    var wreckID: String?
    var description: String?
    var image: Data?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: String? = nil, title: String, number: Double? = nil, wreckID: String? = nil, description: String? = nil, image: Data? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.number = number
        self.wreckID = wreckID
        self.description = description
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
