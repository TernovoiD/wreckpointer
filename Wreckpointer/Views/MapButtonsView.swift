//
//  MapButtonsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.08.2023.
//

import SwiftUI

struct MapButtonsView: View {
    
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                MapMenu()
                CollectionsButtonView()
                Spacer()
            }
            MapSettings()
            MapFilter()
        }
        .padding(.horizontal)
    }
}

struct MapButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonsView()
            .environmentObject(AppData())
            .environmentObject(AppState())
    }
}
