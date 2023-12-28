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
            MapView().tabItem { Label("Map", systemImage: "globe.americas") }
            Circle().tabItem { Label("Home", systemImage: "house.fill") }
            Circle().tabItem { Label("Statisctics", systemImage: "chart.bar.xaxis.ascending") }
            Circle().tabItem { Label("Options", systemImage: "gear.circle") }
            Circle().tabItem { Label("Moderator", systemImage: "lock.rectangle.stack.fill") }
        }
        .alert(isPresented: $wreckpointer.error, content: {
            Alert(title: Text("Error"),
                  message: Text(wreckpointer.errorMessage),
                  dismissButton: .default(Text("Okay"), action: {
                wreckpointer.error = false
            }))
        })
    }
}

#Preview {
    WreckpointerView()
        .environmentObject(WreckpointerNetwork())
}
