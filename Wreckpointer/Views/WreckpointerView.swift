//
//  WreckpointerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.12.2023.
//

import SwiftUI

struct WreckpointerView: View {
    
    @EnvironmentObject var wreckpointer: WreckpointerNetwork
    @EnvironmentObject var store: PurchasesManager
    @State var moderatorTab: Bool = false
    @State var selectedPage: Int = 0
    
    var body: some View {
        TabView(selection: $selectedPage) {
            MapView()
                .tabItem { Label("Map", systemImage: "globe.americas") }
                .tag(0)
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(1)
            Text("Statistic")
                .tabItem { Label("Statisctics", systemImage: "chart.bar.xaxis.ascending") }
                .tag(2)
            OptionsView(showModeratorPage: $moderatorTab)
                .tabItem { Label("Options", systemImage: "gear.circle") }
                .tag(3)
            if moderatorTab {
                ModeratorView()
                    .tabItem { Label("Moderator", systemImage: "lock.rectangle.stack.fill") }
                    .tag(4)
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
        .environmentObject(PurchasesManager())
}
