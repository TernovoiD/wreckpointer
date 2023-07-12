//
//  MainView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.07.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        ZStack {
            MapView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        MainView()
            .environmentObject(MapViewModel(wreckService: WreckService(httpManager: httpManager, dataCoder: dataCoder), coreDataService: CoreDataService(dataCoder: dataCoder)))
    }
}
