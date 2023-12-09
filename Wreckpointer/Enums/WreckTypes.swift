//
//  WreckTypesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckTypes: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case all
    
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
}
