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
    @StateObject var authVM: AuthenticationViewModel
    @StateObject var collectionsVM: CollectionsViewModel
    
    init() {
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wrecksService = WrecksService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        let collectionsService = CollectionsService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        _mapVM = StateObject(wrappedValue: MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService))
        _authVM = StateObject(wrappedValue: AuthenticationViewModel(userService: userService))
        _collectionsVM = StateObject(wrappedValue: CollectionsViewModel(collectionsService: collectionsService))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mapVM)
                .environmentObject(authVM)
                .environmentObject(collectionsVM)
        }
    }
}
