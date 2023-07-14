//
//  CloseButton.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct CloseButton: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                dismissKeyboard()
                mapVM.showLoginView = false
            }
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 25)
                .font(.title3)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .foregroundColor(.purple)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding()
        }
    }
    
    func dismissKeyboard() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window?.endEditing(true)
        
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        CloseButton()
            .environmentObject(mapViewModel)
    }
}
