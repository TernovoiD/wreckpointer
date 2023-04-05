//
//  SelectedCollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 25.03.2023.
//

import SwiftUI

struct SelectedCollectionView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @EnvironmentObject var mapVM: MapViewModel
    let collection: WrecksCollection
    
    var body: some View {
        ScrollView {
            collectionImage
            
            if collection.description != "" {
                collectionDescription
            }
            
            customDivider
            
            if !collectionsVM.collectionWrecks.isEmpty {
                listOfWrecks.padding(.top)
            }
            
            addWreckButton
            
            
            Image("ship1")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .scrollIndicators(.never)
        .navigationTitle(collection.title)
        .toolbar {
            ToolbarItem {
                editCollectionToolbarButton
            }
        }
        .onAppear {
            collectionsVM.loadingWrecks = true
            collectionsVM.fetchWrecks(fromCollection: collection)
        }
    }
}

// MARK: Preview

struct SelectedCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectedCollectionView(collection: WrecksCollection.zeroCollection)
                    .environmentObject(CollectionsViewModel())
                    .environmentObject(MapViewModel())
        }
    }
}

// MARK: Content

extension SelectedCollectionView {
    
    private var collectionImage: some View {
        ZStack {
            AsyncImage(url: collection.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("battleship.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if collectionsVM.loadingWrecks == false {
                seeMapButton
            }
        }
    }
    
    private var collectionDescription: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Information:")
                .font(.title2.weight(.bold))
            Text(collection.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var listOfWrecks: some View {
        ForEach(collectionsVM.collectionWrecks) { wreck in
            Button {
                withAnimation(.spring()) {
                    if collectionsVM.loadingWrecks == false {
                        let wrecks = collectionsVM.collectionWrecks
                        mapVM.mapWrecks = wrecks
                        mapVM.mapSelectedWreck = wreck
                        mapVM.showMap = true
                    }
                }
            } label: {
                WreckRowView(wreck: wreck)
            }
        }
    }
}

// MARK: Design

extension SelectedCollectionView {
    
    private var customDivider: some View {
        Color.primary
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 15)
    }
}

// MARK: Buttons

extension SelectedCollectionView {
    
    private var editCollectionToolbarButton: some View {
        NavigationLink {
            UpdateCollectionView(collection: collection)
        } label: {
            Text("Edit")
        }
    }
    
    private var seeMapButton: some View {
        Button {
            withAnimation(.spring()) {
                let wrecks = collectionsVM.collectionWrecks
                mapVM.mapWrecks = wrecks
                mapVM.showMap = true
            }
        } label: {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "globe")
                    Text("See on map")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.regularMaterial)
            }
        }
    }
    
    private var addWreckButton: some View {
        NavigationLink {
            AddWreckView(collection: collection)
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Add Wreck")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding()
        }
    }
}
