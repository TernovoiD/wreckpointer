//
//  SelectedWreckPanel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 07.08.2023.
//

import SwiftUI

struct SelectedWreckPanel: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    @Binding var showWreck: Bool
    @Binding var wreck: Wreck
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                characteristics
                Spacer()
                buttons
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 200)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay {
            HStack {
                ImageView(imageData: $wreck.image)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .offset(y: -80)
                    .shadow(radius: 10)
                    .padding(.leading)
                Spacer()
            }
            .padding()
        }
        .shadow(radius: 10)
    }
    
    var characteristics: some View {
        VStack(alignment: .leading) {
            Text("Name: \(wreck.title)")
            Text("Latitude: \(abs(wreck.latitude), specifier: "%.2F") \(wreck.latitude >= 0 ? "N" : "S")")
            Text("Longitude: \(abs(wreck.longitude), specifier: "%.2F") \(wreck.longitude >= 0 ? "E" : "W")")
        }
        .font(.headline)
        .padding(.leading)
    }
    
    var buttons: some View {
        VStack {
            moreButton
            editButton
            closeButton
        }
    }
    
    var moreButton: some View {
        Button {
            showWreck = true
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(maxWidth: 10)
                Text("More")
            }
            .padding()
            .font(.headline)
            .frame(maxWidth: 150)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
        }
    }
    
    var editButton: some View {
        Button {
            if let wreck = mapVM.mapSelectedWreck {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        mapVM.wreckToEdit = wreck
                        mapVM.showAddWreckView = true
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "pencil")
                    .frame(maxWidth: 10)
                Text("Edit")
            }
            .padding()
            .font(.headline)
            .frame(maxWidth: 150)
            .foregroundColor(.white)
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
            .contextMenu {
                Button(role: .destructive) {
                    delete()
                } label: {
                    Label("Delete", systemImage: "trash.circle")
                }

            }
        }
    }
    
    var closeButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.changeSelectedWreck(withWreck: nil)
            }
        } label: {
            HStack {
                Image(systemName: "xmark")
                    .frame(maxWidth: 10)
                Text("Close")
            }
            .padding()
            .font(.headline)
            .frame(maxWidth: 150)
            .foregroundColor(.white)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
        }
    }
}

struct SelectedWreckPanel_Previews: PreviewProvider {
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
        
        let wreck = Wreck(cause: "other", type: "all", title: "Titanic", latitude: 41, longitude: -49, wreckDive: false)
        SelectedWreckPanel(showWreck: .constant(false), wreck: .constant(wreck))
            .environmentObject(mapViewModel)
    }
}


// MARK: - Functions

extension SelectedWreckPanel {
    
    private func delete() {
        if let wreck = mapVM.mapSelectedWreck {
            Task {
                do {
                    try await mapVM.delete(wreck)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
