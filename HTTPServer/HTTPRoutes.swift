//
//  HTTPRoutes.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//
import Foundation

public enum ServerURL {
    private var baseURL: String { return "http://127.0.0.1:8080" }
    private var api: String { return "/api/v1" }
    
    // Login
    case login
    // Wrecks
    case wrecks
    case wreck(UUID)
    case wreckImages(UUID)
    case wreckImage(UUID, UUID)
    case wreckApprovedStatus(UUID)
    // Moderators
    case moderators
    case moderator(UUID)
    
    var path: String {
        var endpoint: String
        
        switch self {
        case .login:
            endpoint = "/login"
        case .wrecks:
            endpoint = "/wrecks"
        case .wreck(let uUID):
            endpoint = "/wrecks/\(uUID.uuidString)"
        case .wreckImages(let uUID):
            endpoint = "/wrecks/\(uUID.uuidString)/images"
        case .wreckImage(let uUID, let uUID2):
            endpoint = "/wrecks/\(uUID.uuidString)/images/\(uUID2.uuidString)"
        case .wreckApprovedStatus(let uUID):
            endpoint = "/wrecks/\(uUID.uuidString)/approved-status"
        case .moderators:
            endpoint = "/moderators"
        case .moderator(let uUID):
            endpoint = "/moderators/\(uUID.uuidString)"
        }
        
        return baseURL + api + endpoint
    }
}
