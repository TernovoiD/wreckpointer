//
//  MainView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    @State var scale: Bool = false
    
    var body: some View {
        ZStack {
            MapView()
            MapOverlayView()
                .scaleEffect(mapVM.showLoginView || mapVM.showAddWreckView ? 0.9 : 1)
            AddUpdateWreck()
                .offset(x: mapVM.showAddWreckView ? 0 : 1000)
            AccountView()
                .offset(x: mapVM.showLoginView ? 0 : 1000)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        let userService = UserService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        let authViewModel = AuthenticationViewModel(userService: userService)
        
        MainView()
            .environmentObject(mapViewModel)
            .environmentObject(authViewModel)
    }
}
