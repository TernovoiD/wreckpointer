//
//  WreckpointerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.12.2023.
//

import SwiftUI

struct WreckpointerView: View {
    
    @EnvironmentObject var wreckpointer: WreckpointerNetwork
    @State var moderatorTab: Bool = true
    
    var body: some View {
        TabView {
            MapView().tabItem { Label("Map", systemImage: "globe.americas") }
            Text("Home").tabItem { Label("Home", systemImage: "house.fill") }
            Text("Statistic").tabItem { Label("Statisctics", systemImage: "chart.bar.xaxis.ascending") }
            OptionsView(showModeratorPage: $moderatorTab)
                .tabItem { Label("Options", systemImage: "gear.circle") }
            if moderatorTab {
                ModeratorView()
                    .tabItem { Label("Moderator", systemImage: "lock.rectangle.stack.fill") }
            }
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
