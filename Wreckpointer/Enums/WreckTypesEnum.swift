//
//  WreckTypesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckTypesEnum: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    // Cargo vessels
    case bulkerVessel
    case tankerVessel
    case containerShip
    case passengerShip
    case fishingVessel
    case supplyShip
    case cargoShip
    case platform
    case reefer
    case barge
    case ferry
    case tug
    
    // War ships
    case aircraftCarrier
    case battlecruiser
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
}
