//
//  CollectionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import SwiftUI

struct CollectionsView: View {
    
    @AppStorage("visitedCollections") var visitedCollections: Bool = false
    @StateObject var viewModel: CollectionsViewModel = CollectionsViewModel()
    @EnvironmentObject var collections: Collections
    @EnvironmentObject var state: AppState
    
    
    var body: some View {
        List {
            ForEach(collections.all) { collection in
                NavigationLink {
                    CollectionDetailedView(collection: collection)
                } label: {
                    CollectionView(collection: collection)
                }
                .contextMenu { Button("Delete", role: .destructive) {
                    Task { await viewModel.delete(collection: collection) }
                } }
            }
        }
        .onAppear{ visitedCollections = true }
        .navigationTitle("Collections")
        .toolbar { Button("Add") { collections.all.append(Collection()) } }
        .toolbar { if state.authorizedUser != nil { ToolbarItem { createCollectionButton } } }
        .task { await loadCollections() }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func loadCollections() async {
        if let collections = await viewModel.fetchCollections() {
            self.collections.all = collections
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionsView()
                .environmentObject(CollectionsViewModel())
                .environmentObject(Collections())
                .environmentObject(AppState())
        }
    }
}


// MARK: - Variables

extension CollectionsView {
    
    var createCollectionButton: some View {
        NavigationLink {
            AddUpdateCollection(collection: Collection())
        } label: {
            HStack {
                Text("Create")
                Image(systemName: "plus.circle")
            }
            .font(.headline)
        }
    }
}
