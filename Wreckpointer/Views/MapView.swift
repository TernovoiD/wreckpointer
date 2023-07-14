//
//  MapView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $mapVM.mapRegion, annotationItems: mapVM.wrecksFilterdBySearch()) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                MapPinView(wreck: wreck)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation(.easeInOut) {
                mapVM.searchIsActive = false
                mapVM.openMenu = false
                mapVM.openFilter = false
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        MapView()
            .environmentObject(mapViewModel)
    }
}
