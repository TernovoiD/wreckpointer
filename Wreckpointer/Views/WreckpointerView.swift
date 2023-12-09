//
//  WreckpointerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.12.2023.
//

import SwiftUI

struct WreckpointerView: View {
    
    @StateObject private var viewModel = WreckpointerViewModel()
    @EnvironmentObject var wreckpointerData: WreckpointerData
    @State var moderatoTab: Bool = false
    
    var body: some View {
        TabView {
            MapView().tabItem { Label("Map", systemImage: "map") }
            OptionsView(moderatorTab: $moderatoTab).tabItem { Label("Options", systemImage: "gear") }
            if moderatoTab {
                Circle().tabItem { Label("Moderator", systemImage: "person.fill") }
            }
            
        }
        .task {
//            wreckpointerData.wrecks = await viewModel.loadWrecksFromServer()
        } 
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    WreckpointerView()
        .environmentObject(WreckpointerData())
        .environmentObject(WreckpointerViewModel())
}
