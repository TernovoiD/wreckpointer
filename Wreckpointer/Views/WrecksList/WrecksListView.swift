//
//  WrecksListView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.12.2023.
//

import SwiftUI

struct WrecksListView: View {
    
    @EnvironmentObject var appData: WreckpointerData
    
    var body: some View {
        NavigationView {
            ScrollView {
                listOfWrecks
            }
            .navigationTitle("Wrecks")
            .toolbar {
                Button("Add wreck", systemImage: "plus") {
                    print("Add wreck")
                }
            }
        }
    }
}

#Preview {
    WrecksListView()
        .environmentObject(WreckpointerData())
}

private extension WrecksListView {
    var listOfWrecks: some View {
        LazyVStack {
            ForEach(appData.wrecks) { wreck in
                WreckRowView(wreck: wreck)
            }
        }
    }
}


