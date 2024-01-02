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
    var images: [WreckImage]?
    var type: WreckTypes?
    var cause: WreckCauses?
    var approved: Bool?
    var dive: Bool?
    var dateOfLoss: Date?
    var lossOfLive: Int?
    var history: String?
    var displacement: Int?
    var depth: Int?
    
    static let test = Wreck(id: UUID(uuidString: "12345"), createdAt: Date(), updatedAt: Date(), name: "RMS Titanic", latitude: 31, longitude: -51, images: [ ], type: .passengerShip, cause: .collision, approved: false, dive: false, dateOfLoss: Date(), lossOfLive: 1500, history: "Titanic history", displacement: 13500, depth: 12500)
    
    
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
    
    var hasname: String {
        return name ?? "unknown"
    }
    
    var hastype: WreckTypes {
        return type ?? .unknown
    }
    
    var hascause: WreckCauses {
        return cause ?? .unknown
    }
    
    var isApproved: Bool {
        return approved ?? false
    }
    
    
    var isWreckDive: Bool {
        return dive ?? false
    }
}
