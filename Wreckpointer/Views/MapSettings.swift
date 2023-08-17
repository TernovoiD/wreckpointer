//
//  MapSettings.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct MapSettings: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appData: AppData
    @StateObject private var viewModel = MapSettingsViewModel()
    @AppStorage("saveWrecksInMemory") private var saveWrecksInMemory: Bool = false
    @AppStorage("showFeetUnits") private var showFeetUnits: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openSettingsButton
            if appState.activeUIElement == .mapSettings {
                Divider()
                wrecksSaveToggle
                Divider()
                Toggle(isOn: $showFeetUnits) {
                    Text("Show depth in feet")
                        .padding(.leading)
                }
                Divider()
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
        .onChange(of: saveWrecksInMemory) { newValue in memorySave(newRule: newValue) }
        .onChange(of: appData.serverData, perform: { state in
            if state == .ready {viewModel.saveInMemory(wrecks: appData.wrecks)
            }
        })
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func memorySave(newRule: Bool) {
        if newRule {
            viewModel.saveInMemory(wrecks: appData.wrecks)
        } else {
            viewModel.deleteWrecksFromMemory()
        }
    }
}

struct MapSettings_Previews: PreviewProvider {
    static var previews: some View {
        MapSettings()
            .environmentObject(MapSettingsViewModel())
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}


// MARK: - Variables

extension MapSettings {
    
    private var openSettingsButton: some View {
        Button {
            withAnimation(.easeInOut) {
                appState.activate(element: appState.activeUIElement == .mapSettings ? .none : .mapSettings)
            }
        } label: {
            if appState.activeUIElement == .mapSettings {
                Label("Settings", systemImage: "xmark")
            } else {
                Image(systemName: "gear")
                    .frame(width: 35, height: 35)
                    .font(.title2)
                    .bold()
                    .rotationEffect(Angle(degrees: 90))
            }
        }
    }
    
    private var wrecksSaveToggle: some View {
        VStack {
            Toggle(isOn: $saveWrecksInMemory) {
                Text("Save wrecks in memory")
                    .padding(.leading)
            }
            Text("Saved wrecks will be available in offline mode")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}
