//
//  WreckCausesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckCauses: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case all
    
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
}
