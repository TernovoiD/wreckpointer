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
        ZStack {
            openStoriesButton
                .overlay(alignment: .topTrailing) {
                    starIcon
                        .offset(x: 5, y: -5)
                }
        }
    }
    
    var openStoriesButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.showCollectionsView = true
                mapVM.openSettings = false
                mapVM.openMenu = false
                mapVM.openFilter = false
                mapVM.searchIsActive = false
            }
        } label: {
            Text("Collections")
                .frame(height: 35)
                .font(.headline)
                .padding()
                .accentColorBorder()
        }
    }
    
    var starIcon: some View {
        Text("New!")
            .font(.caption2)
            .bold()
            .padding(3)
            .foregroundColor(.white)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct StoriesButton_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        StoriesButton()
            .environmentObject(mapViewModel)
    }
}
