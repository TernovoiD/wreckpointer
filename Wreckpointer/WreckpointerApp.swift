//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI

@main
struct WreckpointerApp: App {
    
    @StateObject var store = PurchasesManager()
    
    var body: some Scene {
        WindowGroup {
            WreckpointerView()
                .environmentObject(store)
        }
    }
}
