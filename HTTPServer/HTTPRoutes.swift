//
//  HTTPRoutes.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.08.2023.
//
import Foundation

public enum ServerURL {
    private var baseURL: String {
        return "https://wreckpointer-v3-79ac712aeb5d.herokuapp.com"
//        return "http://127.0.0.1:8080"
    }
    private var api: String { return "/api/v1" }
    
    // Login
    case login
    // Wrecks
    case wrecks
    case wreck(UUID)
    case mapWrecks
    case homePageWrecks
    
    var path: String {
        var endpoint: String
        
        switch self {
        case .login:
            endpoint = "/login"
        case .wrecks:
            endpoint = "/wrecks"
        case .wreck(let uUID):
            endpoint = "/wrecks/\(uUID.uuidString)"
        case .mapWrecks:
            endpoint = "/wrecks/map"
        case .homePageWrecks:
            endpoint = "/wrecks/home"
        }
        
        return baseURL + api + endpoint
    }
}
