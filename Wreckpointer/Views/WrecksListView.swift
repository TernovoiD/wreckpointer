//
//  WrecksListView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct WrecksListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mapVM: MapViewModel
    @Binding var selectedWreck: Wreck?
    
    @State var searchText: String = ""
    
    var body: some View {
        List {
            ForEach(searchResults) { wreck in
                WreckView(wreck: wreck)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        selectedWreck = wreck
                        dismiss()
                    }
            }
            .listStyle(.plain)
        }
        .searchable(text: $searchText)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var searchResults: [Wreck] {
        if searchText.isEmpty {
            return mapVM.mapWrecks
        } else {
            return mapVM.mapWrecks.filter { $0.title.contains(searchText) }
        }
    }
}

//struct WrecksListView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        // Init managers
//        let httpManager = HTTPRequestManager()
//        let dataCoder = JSONDataCoder()
//
//        // Init services
//        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
//        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
//        let coreDataService = CoreDataService(dataCoder: dataCoder)
//
//        // Init View model
//        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
//
//        WrecksListView(selectedWreck: .constant(nil))
//            .environmentObject(mapViewModel)
//    }
//}
