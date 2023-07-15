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
    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.5, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: mapVM.wrecksFilterdBySearch()) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                MapPinView(wreck: wreck)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation(.spring()) {
                mapVM.searchIsActive = false
                mapVM.openSettings = false
                mapVM.openMenu = false
                mapVM.openFilter = false
            }
        }
        .onChange(of: mapVM.mapScale) { newValue in
            withAnimation(.easeInOut) {
                adjustMap()
            }
        }
    }
    
    func adjustMap() {
        let mapSpan = mapVM.mapSpan()
        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: mapSpan, longitudeDelta: mapSpan)
        mapRegion.span = mapCoordinateSpan
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
