//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    enum FocusText {
        case searchField
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MapSearchBar()
            HStack(alignment: .top, spacing: 0) {
                MapMenu()
                MapFilterClearButton()
                    .offset(x: mapVM.showWreckDivesOnly == true || mapVM.minimumDate != mapVM.minimumDateOfLossDate() || mapVM.maximumDate != mapVM.maximumDateOfLossDate() || mapVM.wreckType != .all ? 0 : 1000)
                Spacer()
            }
            Spacer()
            MapFilter()
                .offset(y: -20)
        }
    }
}

struct MapOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        MapOverlayView()
            .background(Color.green)
            .environmentObject(mapViewModel)
    }
}
