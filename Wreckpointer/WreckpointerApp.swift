//
//  WreckpointerApp.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 22.03.2023.
//

import SwiftUI

@main
struct WreckpointerApp: App {
    
    @StateObject var mapVM: MapViewModel
    
    init() {
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        _mapVM = StateObject(wrappedValue: MapViewModel(wreckService: wreckService, coreDataService: coreDataService))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mapVM)
        }
    }
}
