//
//  Block.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

struct Block: Codable, Identifiable, Equatable {
    var id: UUID?
    var title: String
    var number: Int
    var wreckID: String?
    var description: String
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: UUID? = nil, title: String, number: Int, wreckID: String? = nil, description: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.number = number
        self.wreckID = wreckID
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(title: String, number: Int, wreckID: String?, description: String) {
        self.id = nil
        self.title = title
        self.number = number
        self.wreckID = wreckID
        self.description = description
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    init() {
        self.id = nil
        self.title = ""
        self.number = 1
        self.wreckID = nil
        self.description = ""
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    static let test = Block(id: UUID(uuidString: "457893472"),
                            title: "KHK Baster",
                            number: 1,
                            wreckID: nil,
                            description: "Holloway attacks by firing a Very pistol into the alien's single eye, temporarily blinding it. While the eye rapidly heals, Holloway races back to Lungfish and returns to the Tigershark. When Dr. Neilson asks about the remainder of their boarding party, Holloway says.",
                            createdAt: Date(),
                            updatedAt: Date())
}
