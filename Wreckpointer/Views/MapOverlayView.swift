//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
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
        }
        .padding()
    }
}

struct MapOverlayView_Previews: PreviewProvider {
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
        
        MapOverlayView()
            .background(Color.green)
            .environmentObject(mapViewModel)
    }
}
