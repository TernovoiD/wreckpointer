//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI
import GoogleMobileAds

@main
struct WreckpointerApp: App {
    
    @StateObject var data = WreckpointerData()
    @StateObject var store = PurchasesManager()
    
    var body: some Scene {
        WindowGroup {
            if let userDefaults = UserDefaults(suiteName: "group.MWQ8P93RWJ.com.danyloternovoi.Wreckpointer") {
                WreckpointerView()
                    .defaultAppStorage(userDefaults)
                    .environmentObject(data)
                    .environmentObject(store)
            } else {
                Text("Failed to load UserDefaults")
            }
        }
    }
}
