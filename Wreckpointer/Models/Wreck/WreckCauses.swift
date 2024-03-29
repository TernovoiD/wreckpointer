//
//  WreckCausesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckCauses: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case grounding
    case collision
    case explosion
    case scuttling
    case flooding
    case breakage
    case weather
    case unknown
    case other
    case fire
    
    var description: String {
        switch self {
        case .grounding:
            return "Grounding"
        case .collision:
            return "Collision"
        case .explosion:
            return "Explosion"
        case .scuttling:
            return "Scuttling"
        case .flooding:
            return "Flooding"
        case .breakage:
            return "Breakage"
        case .weather:
            return "Weather"
        case .unknown:
            return "Unknown"
        case .other:
            return "Other"
        case .fire:
            return "Fire"
        }
    }
}
