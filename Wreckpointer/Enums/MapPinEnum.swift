//
//  MapPinEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.07.2023.
//

enum MapMarkEnum: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case triangle
    case circle
    case xmark
}
