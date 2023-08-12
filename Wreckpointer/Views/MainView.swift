//
//  MainView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                MapOverlayView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Wrecks())
            .environmentObject(Collections())
            .environmentObject(AppState())
    }
}
