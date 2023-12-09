//
//  Wreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct Wreck: Codable, Identifiable, Equatable {
    
    var id: UUID?
    var name: String
    var latitude: Double
    var longitude: Double
    var type: String?
    var cause: String?
    var depth: Double?
    var approved: Bool?
    var isWreckDive: Bool?
    var deadweight: Int?
    var dateOfLoss: Date?
    var lossOfLife: Int?
    var description: String?
    var imageData: Data?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(id: UUID? = nil, name: String, latitude: Double, longitude: Double, type: String? = nil, cause: String? = nil, depth: Double? = nil, approved: Bool? = nil, isWreckDive: Bool, deadweight: Int? = nil, dateOfLoss: Date? = nil, lossOfLife: Int? = nil, description: String? = nil, imageData: Data? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.cause = cause
        self.depth = depth
        self.approved = approved
        self.isWreckDive = isWreckDive
        self.deadweight = deadweight
        self.dateOfLoss = dateOfLoss
        self.lossOfLife = lossOfLife
        self.description = description
        self.imageData = imageData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    static let test = Wreck(id: UUID(uuidString: "54322365"),
                            name: "MHD Terarossa",
                            latitude: 30,
                            longitude: -15,
                            type: "cargoShip",
                            cause: "flooding",
                            depth: 3400,
                            approved: true,
                            isWreckDive: false,
                            deadweight: 30000,
                            dateOfLoss: Date(),
                            lossOfLife: 1500,
                            description: "A submarine is destroyed near the North Pole by a mysterious undersea light. The loss of this and several other ships in the Arctic alarms the world. Governments temporarily close the polar route and convene an emergency meeting at the Pentagon. Present is Commander Dan Wendover (Dick Foran), the captain of the atomic submarine Tigershark, and Nobel Prize-winning scientist Sir Ian Hunt (Tom Conway). The United States Secretary of Defense (Jack Mulhall) leads the meeting; he explains all that is known about the Arctic disasters, and then describes the high-tech capabilities of Tigershark. These include a special hull and a minisub (Lungfish) that can be stored inside the submarine. The secretary finishes by telling Wendover that he is to take Hunt, Tigershark, and her crew to resolve the ship sinkings, and if possible, eliminate their cause.",
                            imageData: nil,
                            createdAt: Date(),
                            updatedAt: Date())
}
