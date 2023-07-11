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
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(MapViewModel())
        }
    }
}
