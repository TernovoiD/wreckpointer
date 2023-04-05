//
//  CollectionsListView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 23.03.2023.
//

import SwiftUI

struct CollectionsListView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    let wreckpointeDescription: String = """
Welcome to Wreckpointer, the ultimate iOS application for shipwreck enthusiasts!

With Wreckpointer, you can explore a vast collection of shipwrecks from all over the world, complete with their fascinating histories and detailed information.
"""
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    Image("ship4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: 1)
                    Text(wreckpointeDescription)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(colors: [ .blue, .indigo, .purple], startPoint: .top, endPoint: .bottom)
                                .contrast(0.2)
                        )
                }
                Text("Collections:")
                    .font(.title.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                listOfCollections
                createNewCollectionButton
                Image("ship2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading)
                    .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Wreckpointer")
            .toolbar {
                ToolbarItem {
                    createNewCollectionToolbarButton
                }
            }
        }
    }
}

// MARK: Preview

struct CollectionsListView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsListView()
            .environmentObject(CollectionsViewModel())
    }
}

// MARK: Content

extension CollectionsListView {
    private var listOfCollections: some View {
        ForEach(collectionsVM.allCollections) { collection in
            NavigationLink {
                SelectedCollectionView(collection: collection)
            } label: {
                CollectionRowView(collection: collection)
            }
        }
    }
}

// MARK: Design

extension CollectionsListView {
    
    var customDivider: some View {
        Color.primary
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 15)
    }
}

// MARK: Buttons

extension CollectionsListView {
    
    private var createNewCollectionToolbarButton: some View {
        NavigationLink {
            AddCollectionView()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    
    private var createNewCollectionButton: some View {
        NavigationLink {
            AddCollectionView()
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Create new Collection")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding()
        }
    }
    
}
