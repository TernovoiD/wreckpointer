//
//  MapOverlayElementsEnum.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 08.12.2023.
//

import Foundation
enum MapOverlayElements: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case search
    case filter
    case add
}
