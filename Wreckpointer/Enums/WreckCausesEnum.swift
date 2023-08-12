//
//  WreckCausesEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

enum WreckCausesEnum: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case grounding
    case collision
    case scuttling
    case flooding
    case breakage
    case weather
    case unknown
    case battle
    case other
    case fire
}
