//
//  MapScales.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

enum mapScales: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case small
    case middle
    case large
}
