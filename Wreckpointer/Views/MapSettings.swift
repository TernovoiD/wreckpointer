//
//  MapSettings.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct MapSettings: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openSettingsButton
            if mapVM.openSettings {
                Divider()
                mapSpanPicker
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
    }
    
    var openSettingsButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openSettings.toggle()
                mapVM.openMenu = false
                mapVM.openFilter = false
                mapVM.searchIsActive = false
            }
        } label: {
            if mapVM.openSettings {
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
    
    var mapSpanPicker: some View {
        VStack {
            Text("Map scale")
                Picker("Map scale", selection: $mapVM.mapScale) {
                    ForEach(mapScales.allCases) { option in
                        Text(String(describing: option).capitalized)
                    }
                }
                .pickerStyle(.segmented)
            Text("This scale will be used to present selected wreck on map.")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

struct MapSettings_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        MapSettings()
            .environmentObject(mapViewModel)
    }
}
