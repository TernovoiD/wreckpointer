//
//  MainView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 25.03.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    
    var body: some View {
        ZStack {
            MapView()
            CollectionsListView()
                .offset(x: mapVM.showMap ? -1000 : 0)
            LoadingView()
                .ignoresSafeArea()
                .offset(x: collectionsVM.loadingCollections ? 0 : -1000)
        }
        .alert(collectionsVM.errorMessage, isPresented: $collectionsVM.error) {
            Button("OK", role: .cancel) {
                collectionsVM.error = false
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MapViewModel())
            .environmentObject(CollectionsViewModel())
    }
}
