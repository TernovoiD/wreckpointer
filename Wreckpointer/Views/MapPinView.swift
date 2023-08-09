//
//  MapPinView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapPinView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    let wreck: Wreck
    
    var body: some View {
        Image(systemName: "signpost.and.arrowtriangle.up.circle.fill")
        .onTapGesture {
            mapVM.changeSelectedWreck(withWreck: wreck)
//            DispatchQueue.main.async {
//                mapVM.mapSelectedWreck = wreck
//            }
        }
    }
}

struct MapPinView_Previews: PreviewProvider {
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
        
        let testWreck: Wreck = Wreck(cause: "something", type: "other", title: "Titanic", latitude: 50, longitude: 50, wreckDive: false)
        ZStack {
            Color.blue
                .ignoresSafeArea()
            MapPinView(wreck: testWreck)
                .environmentObject(mapViewModel)
        }
    }
}
