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
        .onChange(of: mapVM.mapSelectedWreck) { wreck in
            if let wreck {
                DispatchQueue.main.async {
                    showWreck(wreck)
                }
            }
        }
        .onChange(of: mapVM.textToSearch) { text in
            guard !text.isEmpty else { return }
            if let wreck = mapVM.wrecksFilterdBySearch().first {
                showWreck(wreck)
            }
        }
    }
    
    func showWreck(_ wreck: Wreck) {
        let mapSpan = mapVM.mapSpan()
        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: mapSpan, longitudeDelta: mapSpan)
        let mapCoordinate2D = CLLocationCoordinate2D(latitude: wreck.latitude, longitude: wreck.longitude)
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: mapCoordinate2D, span: mapCoordinateSpan)
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
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        MapView()
            .environmentObject(mapViewModel)
    }
}
