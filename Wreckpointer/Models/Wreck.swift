//
//  Wreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import Foundation

struct Wreck: Codable, Identifiable, Equatable {
    
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
    var creator: User?
    
    init(id: UUID? = nil, cause: String, type: String, title: String, image: Data? = nil, depth: Double? = nil, approved: Bool? = nil, latitude: Double, longitude: Double, wreckDive: Bool, dateOfLoss: Date? = nil, information: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, creator: User? = nil) {
        self.id = id
        self.cause = cause
        self.type = type
        self.title = title
        self.image = image
        self.depth = depth
        self.approved = approved
        self.latitude = latitude
        self.longitude = longitude
        self.wreckDive = wreckDive
        self.dateOfLoss = dateOfLoss
        self.information = information
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.creator = creator
    }
    
    init() {
        self.id = nil
        self.cause = WreckCausesEnum.unknown.rawValue
        self.type = WreckTypesEnum.other.rawValue
        self.title = ""
        self.image = nil
        self.depth = nil
        self.approved = nil
        self.latitude = 0
        self.longitude = 0
        self.wreckDive = false
        self.dateOfLoss = nil
        self.information = nil
        self.createdAt = nil
        self.updatedAt = nil
        self.creator = nil
    }
    
    static let test = Wreck(id: UUID(uuidString: "54322365"),
                            cause: "flooding",
                            type: "cargoShip",
                            title: "MHD Terarossa",
                            image: nil,
                            depth: 3400,
                            approved: true,
                            latitude: 30,
                            longitude: 15,
                            wreckDive: false,
                            dateOfLoss: Date(),
                            information: "A submarine is destroyed near the North Pole by a mysterious undersea light. The loss of this and several other ships in the Arctic alarms the world. Governments temporarily close the polar route and convene an emergency meeting at the Pentagon. Present is Commander Dan Wendover (Dick Foran), the captain of the atomic submarine Tigershark, and Nobel Prize-winning scientist Sir Ian Hunt (Tom Conway). The United States Secretary of Defense (Jack Mulhall) leads the meeting; he explains all that is known about the Arctic disasters, and then describes the high-tech capabilities of Tigershark. These include a special hull and a minisub (Lungfish) that can be stored inside the submarine. The secretary finishes by telling Wendover that he is to take Hunt, Tigershark, and her crew to resolve the ship sinkings, and if possible, eliminate their cause.",
                            createdAt: Date(),
                            updatedAt: Date(),
                            creator: User.test)
}
