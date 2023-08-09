//
//  MapSearchBar.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapSearchBar: View {
    
    @FocusState var selectedField: FocusText?
    @EnvironmentObject var mapVM: MapViewModel
    
    enum FocusText {
        case searchField
    }
    
    var body: some View {
        HStack {
            searchBar
            if !mapVM.textToSearch.isEmpty {
                searchBarClearButton
            }
        }
    }
    
    var searchBar: some View {
        TextField("Search", text: $mapVM.textToSearch)
            .padding()
            .focused($selectedField, equals: .searchField)
            .background(mapVM.wrecksFilterdBySearch().count == 0 && !mapVM.textToSearch.isEmpty ? Color.red.opacity(0.3) : Color.clear)
            .neonField(light: selectedField == .searchField ? true : false)
            .submitLabel(.search)
            .autocorrectionDisabled(true)
            .onTapGesture {
                selectedField = .searchField
            }
            .onSubmit {
                selectedField = .none
            }
            .onChange(of: selectedField, perform: { newValue in
                mapVM.searchIsActive = newValue == .searchField ? true : false
            })
            .onChange(of: mapVM.searchIsActive) { newValue in
                if newValue == false {
                    selectedField = .none
                } else {
                    withAnimation(.easeInOut) {
                        mapVM.openFilter = false
                        mapVM.openMenu = false
                        mapVM.openSettings = false
                    }
                }
            }
    }
    
    var searchBarClearButton: some View {
        Button {
            mapVM.textToSearch = ""
            selectedField = .none
        } label: {
            Image(systemName: "xmark")
                .font(.title2)
                .padding()
                .background(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: .green, radius: 7)
        }
    }
}

struct MapSearchBar_Previews: PreviewProvider {
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
            MapSearchBar()
                .environmentObject(mapViewModel)
        }
    }
}
