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
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var type: WreckTypes?
    var cause: WreckCauses?
    var approved: Bool?
    var dive: Bool?
    var dateOfLoss: Date?
    var lossOfLive: Int?
    var displacement: Int?
    var depth: Int?
    var image: Data?
    var history: String?
    
    static let test = Wreck(id: UUID(uuidString: "12345"), createdAt: Date(), updatedAt: Date(), name: "RMS Titanic", latitude: 31, longitude: -43, type: .passengerShip, cause: .collision, approved: true, dive: false, dateOfLoss: Date(), lossOfLive: 1500, displacement: 50000, depth: 12500, image: nil, history: "Explore verified shipwrecks in our curated collection, rigorously checked by our team. Uncover tales of lost vessels, updated regularly for accuracy. Delve into maritime history's mysteries with our diverse array of submerged relics. Join us on this intriguing journey through time and sea lore. Happy exploring!")
    
    
    // Computed properties
    
    var hasCoordinates: (areValid: Bool, latitude: Double, longitude: Double) {
        let areValid = latitude != nil && longitude != nil
        let validLatitude = latitude ?? 0
        let validLongitude = longitude ?? 0
        return (areValid, validLatitude, validLongitude)
    }
    
    var hasDateOfLoss: (isValid: Bool, date: Date) {
        let isValid = dateOfLoss != nil
        let validDate = dateOfLoss ?? Date()
        return (isValid, validDate)
    }
    
    var hasName: String {
        return name ?? "unknown"
    }
    
    var hasType: WreckTypes {
        return type ?? .unknown
    }
    
    var hasCause: WreckCauses {
        return cause ?? .unknown
    }
    
    var hasDisplacement: (isValid: Bool, tons: Int) {
        let isValid = displacement != nil
        let validTons = displacement ?? 0
        return (isValid, validTons)
    }
    
    var hasDepth: (isValid: Bool, ft: Int) {
        let isValid = depth != nil
        let validFt = depth ?? 0
        return (isValid, validFt)
    }
    
    var hasLossOfLife: (isValid: Bool, souls: Int) {
        let isValid = lossOfLive != nil
        let souls = lossOfLive ?? 0
        return (isValid, souls)
    }
    
    var isApproved: Bool {
        return approved ?? false
    }
    
    
    var isWreckDive: Bool {
        return dive ?? false
    }
}
