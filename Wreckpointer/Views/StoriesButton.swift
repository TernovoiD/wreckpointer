//
//  StoriesButton.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct StoriesButton: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        openStoriesButton
            .frame(width: 35, height: 35)
            .font(.headline)
            .padding()
            .accentColorBorder()
            .onTapGesture {
                withAnimation(.easeInOut) {
                    mapVM.openSettings.toggle()
                    mapVM.openMenu = false
                    mapVM.openFilter = false
                    mapVM.searchIsActive = false
                }
            }
    }
    
    var openStoriesButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openSettings = false
                mapVM.openMenu = false
                mapVM.openFilter = false
                mapVM.searchIsActive = false
            }
        } label: {
            Image(systemName: "text.book.closed")
                .font(.title2)
                .bold()
        }
    }
}

struct StoriesButton_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        StoriesButton()
            .environmentObject(mapViewModel)
    }
}
