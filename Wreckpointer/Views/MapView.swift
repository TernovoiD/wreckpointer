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
        Map(coordinateRegion: $mapVM.mapRegion, annotationItems: mapVM.mapWrecks) { wreck in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: wreck.latitude,
                                                             longitude: wreck.longitude)) {
                Circle()
                    .size(width: 10, height: 10)
            }
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        MapView()
            .environmentObject(MapViewModel(wreckService: WreckService(httpManager: httpManager, dataCoder: dataCoder), coreDataService: CoreDataService(dataCoder: dataCoder)))
    }
}
