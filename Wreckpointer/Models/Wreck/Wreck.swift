//
//  File.swift
//  
//
//  Created by Danylo Ternovoi on 24.12.2023.
//

import Foundation

struct Wreck: Codable, Identifiable, Equatable {
    let id: UUID?
    let createdAt: Date?
    let updatedAt: Date?
    
    var name: String
    var latitude: Double
    var longitude: Double
    var info: WreckInfo?
    var images: [WreckImage]
    
    static let test = Wreck(id: UUID(uuidString: "12345"), createdAt: Date(), updatedAt: Date(), name: "RMS Titanic", latitude: 34, longitude: -51, info: WreckInfo.test, images: [ ])
}

struct WreckInfo: Codable, Identifiable, Equatable {
    let id: UUID?
    let createdAt: Date?
    let updatedAt: Date?
    
    var type: WreckTypes?
    var cause: WreckCauses?
    var isWreckDive: Bool?
    var dateOfLoss: Date?
    var lossOfLife: Int?
    var history: String?
    var deadweight: Int?
    var depth: Int?
    
    static let test = WreckInfo(id: UUID(uuidString: "678910"), createdAt: Date(), updatedAt: Date(), type: .unknown, cause: .unknown, isWreckDive: false, dateOfLoss: Date(), lossOfLife: 0, history: "Deep history", deadweight: 0, depth: 0)
}

struct WreckImage: Codable, Identifiable, Equatable {
    let id: UUID?
    let createdAt: Date?
    let updatedAt: Date?
    let data: Data
}
