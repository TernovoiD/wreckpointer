//
//  CollectionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import SwiftUI

struct CollectionsView: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @State var blankCollection: Collection = Collection(title: "", description: "", blocks: [])

    var body: some View {
        NavigationView {
            collectionsList
                .navigationTitle("Collections")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        mapButton
                    }
                    ToolbarItem {
                        createCollectionButton
                    }
                }
        }
        .task {
            do {
                try await collectionsVM.fetch()
            } catch let error {
                print(error)
            }
        }
    }
    
    var collectionsList: some View {
        List {
            ForEach(collectionsVM.collections) { collection in
                NavigationLink {
                    CollectionDetailedView(collection: collection)
                } label: {
                    CollectionView(collection: collection)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        delete(collection: collection)
                    } label: {
                        Label("Delete", systemImage: "trash.circle")
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
    
    var mapButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.showCollectionsView = false
            }
        } label: {
            HStack {
                Image(systemName: "globe.europe.africa.fill")
                Text("Back to Map")
            }
            .font(.headline)
        }
    }
    
    var createCollectionButton: some View {
        NavigationLink {
            AddUpdateCollection(originalCollection: $blankCollection, collection: blankCollection)
        } label: {
            HStack {
                Text("Create")
                Image(systemName: "plus.circle")
            }
            .font(.headline)
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        let collectionsService = CollectionsService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
 
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        let collectionsViewModel = CollectionsViewModel(collectionsService: collectionsService)
        
        CollectionsView()
            .environmentObject(mapViewModel)
            .environmentObject(collectionsViewModel)
    }
}


// MARK: - Functions

extension CollectionsView {
    
    private func delete(collection: Collection) {
        Task {
            do {
                try await collectionsVM.delete(collection: collection)
                collectionsVM.collections.removeAll(where: { $0.id == collection.id })
            } catch let error {
                print(error)
            }
        }
    }
}
