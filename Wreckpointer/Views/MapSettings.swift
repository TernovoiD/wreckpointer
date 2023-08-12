//
//  MapSettings.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct MapSettings: View {
    
    @AppStorage("saveWrecksInMemory") private var saveWrecksInMemory: Bool = true
    @AppStorage("showFeetUnits") var showFeetUnits: Bool = true
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openSettingsButton
            if state.activeUIElement == .mapSettings {
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
    }
    
    var openSettingsButton: some View {
        Button {
            withAnimation(.easeInOut) {
                state.activeUIElement = state.activeUIElement == .mapSettings ? .none : .mapSettings
            }
        } label: {
            if state.activeUIElement == .mapSettings {
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
    
    var wrecksSaveToggle: some View {
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

struct MapSettings_Previews: PreviewProvider {
    static var previews: some View {
        MapSettings()
            .environmentObject(AppState())
    }
}
