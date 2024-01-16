//
//  WreckpointerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.12.2023.
//

import SwiftUI

struct WreckpointerView: View {
    
    @AppStorage("moderatorTab",store: UserDefaults(suiteName: "group.com.danyloternovoi.Wreckpointer"))
    var moderatorTab: Bool = false
    @State var selectedPage: Int = 1
    
    var body: some View {
        TabView(selection: $selectedPage) {
            MapView()
                .tabItem { Label("Map", systemImage: "globe.americas") }
                .tag(0)
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(1)
            OptionsView(showModeratorPage: $moderatorTab)
                .tabItem { Label("Options", systemImage: "gear.circle") }
                .tag(2)
            if moderatorTab {
                ModeratorView()
                    .tabItem { Label("Moderator", systemImage: "lock.rectangle.stack.fill") }
                    .tag(3)
            }
        }
    }
}

#Preview {
    WreckpointerView()
}
