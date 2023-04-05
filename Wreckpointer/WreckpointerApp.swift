//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI

@main
struct WreckpointerApp: App {
    @StateObject var MapVM = MapViewModel()
    @StateObject var CollectionsVM = CollectionsViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(MapViewModel())
                .environmentObject(CollectionsViewModel())
        }
    }
}
