//
//  WreckTypesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckTypes: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    // Cargo vessels
    case bulkerVessel
    case tankerVessel
    case fishingVessel
    case containerShip
    case passengerShip
    case supplyShip
    case cargoShip
    case platform
    case reefer
    case barge
    case ferry
    case tug
    
    // War ships
    case aircraftCarrier
    case battleCruiser
    case dreadnought
    case landingShip
    case battleship
    case submarine
    case destroyer
    case corvette
    case frigate
    case cruiser
    case warship
    
    // Airplanes
    case passengerPlane
    case cargoPlane
    case warPlane
    
    // Other
    case helicopter
    case unknown
    case other
    
    var description: String {
        switch self {
        case .bulkerVessel:
            return "Bulker vessel"
        case .tankerVessel:
            return "Tanker vessel"
        case .fishingVessel:
            return "Fishing vessel"
        case .containerShip:
            return "Container ship"
        case .passengerShip:
            return "Passanger ship"
        case .supplyShip:
            return "Supply vessel"
        case .cargoShip:
            return "Cargo vessel"
        case .platform:
            return "Platform"
        case .reefer:
            return "Reefer vessel"
        case .barge:
            return "Barge"
        case .ferry:
            return "Ferry"
        case .tug:
            return "Tug"
        case .aircraftCarrier:
            return "Aircraft carrier"
        case .battleCruiser:
            return "Battlecruiser"
        case .dreadnought:
            return "Dreadnought"
        case .landingShip:
            return "Landing ship"
        case .battleship:
            return "Battleship"
        case .submarine:
            return "Submarine"
        case .destroyer:
            return "Destroyer"
        case .corvette:
            return "Corvette"
        case .frigate:
            return "Frigate"
        case .cruiser:
            return "Cruiser"
        case .warship:
            return "Warship"
        case .passengerPlane:
            return "Passenger plane"
        case .cargoPlane:
            return "Cargo plane"
        case .warPlane:
            return "Warplane"
        case .helicopter:
            return "Helicopter"
        case .unknown:
            return "Unknown type"
        case .other:
            return "Other type"
        }
    }
}
