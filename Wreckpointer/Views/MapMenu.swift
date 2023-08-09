//
//  MapMenu.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapMenu: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openCloseMenuButton
            if mapVM.openMenu {
                Divider()
                    .frame(maxWidth: 120)
                accountButton
                addWreckButton
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
        .onTapGesture {
            withAnimation(.easeInOut) {
                mapVM.openMenu = true
                mapVM.openFilter = false
                mapVM.openSettings = false
                mapVM.searchIsActive = false
            }
        }
    }
    
    var openCloseMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openMenu.toggle()
                mapVM.openFilter = false
                mapVM.openSettings = false
                mapVM.searchIsActive = false
            }
        } label: {
            if mapVM.openMenu {
                Label("Menu", systemImage: "xmark")
            } else {
                Image(systemName: "text.justify")
                    .frame(width: 35, height: 35)
                    .font(.title2)
                    .bold()
                    .rotationEffect(Angle(degrees: 90))
            }
        }
    }
    
    var settingsButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "gear")
                    .frame(maxWidth: 20)
                Text("Settings")
            }
        }
    }
    
    var accountButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.showLoginView = true
                mapVM.openMenu = false
            }
        } label: {
            HStack {
                Image(systemName: "person.crop.rectangle")
                    .frame(maxWidth: 20)
                Text("Account")
            }
        }
    }
    
    var addWreckButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.wreckToEdit = nil
                mapVM.openMenu = false
                mapVM.showAddWreckView = true
            }
        } label: {
            HStack {
                Image(systemName: "plus.rectangle")
                    .frame(maxWidth: 20)
                Text("Add Wreck")
            }
            .frame(maxWidth: 140, alignment: .leading)
        }
    }
}

struct MapMenu_Previews: PreviewProvider {
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
        
        ZStack {
            Color.indigo
                .ignoresSafeArea()
            MapMenu()
                .environmentObject(mapViewModel)
        }
    }
}
