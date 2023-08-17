//
//  AppState.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import Foundation

@MainActor
class AppState: ObservableObject {
    @Published var authorizedUser: User?
    @Published var activeUIElement: UIElement?
    @Published var selectedWreck: Wreck?
    
    func authorize(user: User?) {
        authorizedUser = user
    }
    
    func activate(element: UIElement?) {
        activeUIElement = element
    }
    
    func select(wreck: Wreck?) {
        if let wreck {
            selectedWreck = wreck
            activeUIElement = .mapSelected
        } else { selectedWreck = nil }
    }
    
    func fetchUser() async {
        do {
            authorizedUser = try await UserManager.shared.fetchUser()
        } catch { authorizedUser = nil }
    }
}


extension AppState {
    
    enum UIElement: String, Codable, CaseIterable, Identifiable, Equatable {
        var id: Self { self }
        
        case mapMenu
        case mapSettings
        case mapFilter
        case mapSearch
        case mapSelected
    }
}
