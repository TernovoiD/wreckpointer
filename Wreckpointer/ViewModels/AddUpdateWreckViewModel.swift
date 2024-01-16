//
//  AddUpdateWreckViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation

final class AddUpdateWreckViewModel: ObservableObject {
    
    @Published var id: UUID? = nil
    @Published var image: Data? = nil
    @Published var name: String = ""
    @Published var type: WreckTypes = .unknown
    @Published var cause: WreckCauses = .unknown
    @Published var isApproved: Bool = false
    @Published var isWreckDive: Bool = false
    @Published var dateOfLoss: Date = Date()
    @Published var dateOfLossKnown: Bool = false
    @Published var lossOfLive: String = ""
    @Published var history: String = ""
    @Published var displacement: String = ""
    @Published var depth: String = ""
    // Coordinates
    @Published var latitudeDegrees: String = ""
    @Published var latitudeMinutes: String = ""
    @Published var latitudeSeconds: String = ""
    @Published var latitudeNorth: Bool = true
    @Published var longitudeDegrees: String = ""
    @Published var longitudeMinutes: String = ""
    @Published var longitudeSeconds: String = ""
    @Published var longitudeEast: Bool = false
    
    var wreckLatitude: Double? {
        let degrees = latitudeDegrees.isEmpty ? "00" : latitudeDegrees
        let minutes = latitudeMinutes.isEmpty ? "00" : latitudeMinutes
        let seconds = latitudeSeconds.isEmpty ? "00" : latitudeSeconds
        
        if let latitude = Double(degrees + "." + minutes + seconds) {
            return latitudeNorth ? latitude : -latitude
        } else {
            return nil
        }
    }
    
    var wreckLongitude: Double? {
        let degrees = longitudeDegrees.isEmpty ? "00" : longitudeDegrees
        let minutes = longitudeMinutes.isEmpty ? "00" : longitudeMinutes
        let seconds = longitudeSeconds.isEmpty ? "00" : longitudeSeconds
        
        if let latitude = Double(degrees + "." + minutes + seconds) {
            return longitudeEast ? latitude : -latitude
        } else {
            return nil
        }
    }
    
    func fill(wreck: Wreck) {
        id = wreck.id
        image = wreck.image
        name = wreck.hasName
        type = wreck.hasType
        cause = wreck.hasCause
        isWreckDive = wreck.isWreckDive
        isApproved = wreck.isApproved
        dateOfLoss = wreck.hasDateOfLoss.date
        dateOfLossKnown = wreck.hasDateOfLoss.isValid
        lossOfLive = wreck.hasLossOfLife.isValid ? String(wreck.hasLossOfLife.souls) : ""
        history = wreck.history ?? ""
        displacement = wreck.hasDisplacement.isValid ? String(wreck.hasDisplacement.tons) : ""
        depth = wreck.hasDepth.isValid ? String(wreck.hasDepth.ft) : ""
        latitudeDegrees = wreck.hasCoordinates.latitude.getCoordinates().degrees
        latitudeMinutes = wreck.hasCoordinates.latitude.getCoordinates().minutes
        latitudeSeconds = wreck.hasCoordinates.latitude.getCoordinates().seconds
        latitudeNorth = wreck.hasCoordinates.latitude >= 0 ? true : false
        longitudeDegrees = wreck.hasCoordinates.longitude.getCoordinates().degrees
        longitudeMinutes = wreck.hasCoordinates.longitude.getCoordinates().minutes
        longitudeSeconds = wreck.hasCoordinates.longitude.getCoordinates().seconds
        longitudeEast = wreck.hasCoordinates.longitude >= 0 ? true : false
    }
    
    func getUpdatedWreck() -> Wreck {
        return Wreck(id: id,
                     createdAt: nil,
                     updatedAt: nil,
                     name: name.isEmpty ? nil : name,
                     latitude: wreckLatitude,
                     longitude: wreckLongitude,
                     type: type,
                     cause: cause,
                     approved: isApproved,
                     dive: isWreckDive,
                     dateOfLoss: dateOfLossKnown ? dateOfLoss : nil,
                     lossOfLive: lossOfLive.isEmpty ? nil : Int(lossOfLive),
                     displacement: displacement.isEmpty ? nil : Int(displacement),
                     depth: depth.isEmpty ? nil : Int(depth),
                     image: image,
                     history: history.isEmpty ? nil : history)
    }
}
