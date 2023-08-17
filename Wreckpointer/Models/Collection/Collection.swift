//
//  Collection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation

struct Collection: Codable, Identifiable, Equatable {
    
    var id: UUID?
    var title: String
    var description: String
    var image: Data?
    var createdAt: Date?
    var updatedAt: Date?
    var blocks: [Block]
    var approved: Bool?
    var creator: User?
    
    init(id: UUID? = nil, title: String, description: String, image: Data? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, blocks: [Block], approved: Bool? = nil, creator: User? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.blocks = blocks
        self.approved = approved
        self.creator = creator
    }
    
    init(title: String, description: String, image: Data? = nil) {
        self.id = nil
        self.title = title
        self.description = description
        self.image = image
        self.createdAt = nil
        self.updatedAt = nil
        self.blocks = [ ]
        self.approved = nil
        self.creator = nil
    }
    
    init() {
        self.id = nil
        self.title = ""
        self.description = ""
        self.image = nil
        self.createdAt = nil
        self.updatedAt = nil
        self.blocks = [ ]
        self.approved = nil
        self.creator = nil
    }
    
    static let test = Collection(id: UUID(uuidString: "634528709"),
                                 title: "Atomic liners",
                                 description: "A submarine is destroyed near the North Pole by a mysterious undersea light. The loss of this and several other ships in the Arctic alarms the world. Governments temporarily close the polar route and convene an emergency meeting at the Pentagon. Present is Commander Dan Wendover (Dick Foran), the captain of the atomic submarine Tigershark, and Nobel Prize-winning scientist Sir Ian Hunt (Tom Conway). The United States Secretary of Defense (Jack Mulhall) leads the meeting; he explains all that is known about the Arctic disasters, and then describes the high-tech capabilities of Tigershark. These include a special hull and a minisub (Lungfish) that can be stored inside the submarine. The secretary finishes by telling Wendover that he is to take Hunt, Tigershark, and her crew to resolve the ship sinkings, and if possible, eliminate their cause.",
                                 image: nil,
                                 createdAt: Date(),
                                 updatedAt: Date(),
                                 blocks: [Block.test, Block.test],
                                 approved: true,
                                 creator: User.test)
}
