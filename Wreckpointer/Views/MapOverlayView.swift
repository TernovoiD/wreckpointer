//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    @State var showWreck: Bool = false
    @State var wreckToShow: Wreck = Wreck(cause: "unknown", type: "unknown", title: "unknown", latitude: 0, longitude: 0, wreckDive: false)
    
    enum FocusText {
        case searchField
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            MapSearchBar()
            HStack(alignment: .top, spacing: 10) {
                MapMenu()
                StoriesButton()
            }
            MapSettings()
            MapFilter()
            Spacer()
            SelectedWreckPanel(showWreck: $showWreck, wreck: $wreckToShow)
                .offset(y: mapVM.mapSelectedWreck == nil ? 1000 : -20)
        }
        .onChange(of: mapVM.mapSelectedWreck, perform: { newValue in
            if let wreck = newValue {
                wreckToShow = wreck
            }
        })
        .sheet(isPresented: $showWreck, content: {
            if let wreck = mapVM.mapSelectedWreck {
                WreckDetailedView(wreck: wreck)
            } else {
                let wreck = Wreck(cause: "unknown", type: "unknown", title: "unknown", latitude: 0, longitude: 0, wreckDive: false)
                WreckDetailedView(wreck: wreck)
            }
        })
        .padding()
    }
}

struct MapOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        MapOverlayView()
            .background(Color.green)
            .environmentObject(mapViewModel)
    }
}
