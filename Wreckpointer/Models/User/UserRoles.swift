//
//  UserRoles.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

enum UserRoles: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case user
    case moderator
    case admin
}
