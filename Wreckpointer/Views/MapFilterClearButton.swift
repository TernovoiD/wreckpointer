//
//  MapFilterClearButton.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapFilterClearButton: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.showWreckDivesOnly = false
                mapVM.minimumDate = mapVM.minimumDateOfLossDate()
                mapVM.maximumDate = mapVM.maximumDateOfLossDate()
                mapVM.wreckType = .all
                mapVM.openFilter = false
            }
        } label: {
            Text("Clear filter")
                .font(.title3)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .foregroundColor(.purple)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}

struct MapFilterClearButton_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        MapFilterClearButton()
            .environmentObject(mapViewModel)
    }
}
