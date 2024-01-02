//
//  WreckImage.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 01.01.2024.
//

import Foundation

struct WreckImage: Codable, Identifiable, Equatable {
    let id: UUID?
    let createdAt: Date?
    let updatedAt: Date?
    let data: Data
}
