//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI

@main
struct WreckpointerApp: App {
    
    @StateObject var appState = AppState()
    @StateObject var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(AppState())
                .environmentObject(AppData())
        }
    }
}
