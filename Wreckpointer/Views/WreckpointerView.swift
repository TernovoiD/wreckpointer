//
//  WreckpointerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.12.2023.
//

import SwiftUI

struct WreckpointerView: View {
    
    @EnvironmentObject var wreckpointer: WreckpointerNetwork
    @State var moderatoTab: Bool = false
    
    var body: some View {
        TabView {
            Circle().tabItem { Label("Circle", systemImage: "circle") }
            Circle().tabItem { Label("Circle", systemImage: "circle") }
            Circle().tabItem { Label("Circle", systemImage: "circle") }
            
        }
//        .task { await wreckpointer.loadWrecksFromServer() }
        .alert(wreckpointer.errorMessage, isPresented: $wreckpointer.error) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    WreckpointerView()
        .environmentObject(WreckpointerNetwork())
}
