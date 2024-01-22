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
    var lossOfLife: Int?
    var displacement: Int?
    var depth: Int?
    var image: Data?
    var history: String?
    
    
    static let test = Wreck(id: UUID(uuidString: "12345"), 
                            createdAt: Date(),
                            updatedAt: Date(),
                            name: "RMS Lusitania",
                            latitude: 31,
                            longitude: -123.4353,
                            type: .passengerShip,
                            cause: .collision,
                            approved: true,
                            dive: false,
                            dateOfLoss: Date(),
                            lossOfLife: 1500,
                            displacement: 50000,
                            depth: 12500,
                            image: nil,
                            history: "Lusitania (named after the Roman province in Western Europe corresponding to modern Portugal) was an ocean liner that was launched by the Cunard Line in 1906 and held the Blue Riband appellation for the fastest Atlantic crossing in 1908. It was briefly the world's largest passenger ship until the completion of the Mauretania three months later. She was sunk on her 202nd trans-Atlantic crossing, on 7 May 1915, by a German U-boat 11 miles (18 km) off the Old Head of Kinsale, Ireland, killing 1,199 passengers and crew. The sinking occurred about two years before the United States declaration of war on Germany. Although the Lusitania's sinking was a major factor in building American support for a war, war was eventually declared only after the Imperial German Government resumed the use of unrestricted submarine warfare against American shipping in an attempt to break the Transatlantic supply chain from the US to Britain, as well as after the Zimmermann Telegram. German shipping lines were Cunard's main competitors for the custom of Transatlantic passengers in the early 20th century, and Cunard responded by building two new 'ocean greyhounds': the Lusitania and the Mauretania. Cunard used assistance from the British Admiralty to build both new ships, on the understanding that the ship would be available for military duty in time of war. During construction gun mounts for deck cannons were installed but no guns were ever fitted. Both the Lusitania and Mauretania were fitted with turbine engines that enabled them to maintain a service speed of 24 knots (44 km/h; 28 mph). They were equipped with lifts, wireless telegraph, and electric light, and provided 50 percent more passenger space than any other ship; the first-class decks were known for their sumptuous furnishings.")
    
    
    // Computed properties
    
    var hasCoordinates: (areValid: Bool, 
                         latitude: Double,
                         longitude: Double) {
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
    
    var hasUpdate: (isValid: Bool, date: Date) {
        let isValid = updatedAt != nil
        let validDate = updatedAt ?? Date()
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
        let isValid = lossOfLife != nil
        let souls = lossOfLife ?? 0
        return (isValid, souls)
    }
    
    var isApproved: Bool {
        return approved ?? false
    }
    
    
    var isWreckDive: Bool {
        return dive ?? false
    }
}
