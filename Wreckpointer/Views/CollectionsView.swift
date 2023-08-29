//
//  CollectionsView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import SwiftUI

struct CollectionsView: View {
    
    @AppStorage("visitedCollections") var visitedCollections: Bool = false
    @StateObject var viewModel = CollectionsViewModel()
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                collections
            }
            .padding(.horizontal)
        }
        .onAppear{ visitedCollections = true }
        .navigationTitle("Collections")
        .task { if appData.collections.isEmpty { await appData.loadCollections() }}
        .toolbar { if appState.authorizedUser != nil { ToolbarItem { createCollectionButton } } }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func authorized(forCollection collection: Collection) -> Bool {
        appState.authorizedUser == collection.creator || appState.authorizedUser?.role == "moderator"
    }
    
    private func empty(collection: Collection) -> Bool {
        appState.authorizedUser == collection.creator || appState.authorizedUser?.role == "moderator" || collection.creator == nil
    }
    
    private func deleteCollection(collection: Collection) async {
        let result = await viewModel.delete(collection: collection)
        if result {
            withAnimation(.easeInOut) {
                appData.collections.removeAll(where: { $0.id == collection.id })
            }
        }
    }
}

struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionsView()
                .environmentObject(CollectionsViewModel())
                .environmentObject(AppData())
                .environmentObject(AppState())
        }
    }
}


// MARK: - Variables

extension CollectionsView {
    
    private var collections: some View {
        ForEach($appData.collections) { $collection in
            HStack {
                NavigationLink {
                    CollectionDetailedView(collection: collection)
                } label: {
                    CollectionView(collection: $collection)
                        .contextMenu { Button("Delete", role: .destructive) {
                            Task { await deleteCollection(collection: collection) } }
                        }
                }
                if empty(collection: collection) {
                    VStack {
                        if empty(collection: collection) {
                            NavigationLink {
                                AddUpdateCollection(collection: $collection, collectionImage: collection.image, collectionName: collection.title, collectionDescription: collection.description)
                            } label: { updateCollectionButton }
                        }
                        Spacer()
                        if authorized(forCollection: collection) {
                            Button {
                                Task { await deleteCollection(collection: collection) }
                            } label: { deleteCollectionButton }
                        }
                    }
                    .frame(maxHeight: 120)
                }
            }
        }
    }
    
    private var createCollectionButton: some View {
        NavigationLink {
            AddUpdateCollection(collection: .constant(Collection()))
        } label: {
            HStack {
                Text("Create")
                Image(systemName: "plus.rectangle")
            }
            .font(.headline)
        }
    }
    
    private var updateCollectionButton: some View {
            HStack {
                Image(systemName: "pencil.circle")
                    .frame(maxWidth: 10)
                Text("Edit")
            }
            .padding()
            .bold()
            .frame(maxHeight: .infinity)
            .frame(maxWidth: 120)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 5)
    }
    
    private var deleteCollectionButton: some View {
        HStack {
            Image(systemName: "trash.circle")
                .frame(maxWidth: 10)
            Text("Delete")
        }
        .padding()
        .bold()
        .frame(maxHeight: .infinity)
        .frame(maxWidth: 120)
        .foregroundColor(.white)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(radius: 5)
    }
}
