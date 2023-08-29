//
//  CollectionDetailedView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionDetailedView: View {
    
    @StateObject private var viewModel = CollectionDetailViewModel()
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var appState: AppState
    @State var collection: Collection
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text(collection.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.leading, 5)
                .padding(.top)
            if appState.authorizedUser == collection.creator || appState.authorizedUser?.role == "moderator" {
                addBlockButton
                    .padding(.leading, 5)
            }
            collectionBlocks
            if let creator = collection.creator {
                CreatorView(creator: creator)
                    .padding(.vertical)
            }
        }
        .navigationTitle(collection.title)
        .onAppear { sortBlocks() }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: appData.collections, perform: { collections in
            if let index = collections.firstIndex(where: { $0.id == collection.id }) {
                collection = collections[index]
            }
        })
    }
    
    private func sortBlocks() {
        collection.blocks.sort(by: { $0.number < $1.number })
    }
    
    func delete(block: Block) async {
        let result = await viewModel.delete(block: block, collectionID: collection.id)
        if result {
            collection.blocks.removeAll(where: { $0.id == block.id })
            
            if let index = appData.collections.firstIndex(where: { $0.id == collection.id }) {
                appData.collections[index].blocks.removeAll(where: { $0.id == block.id })
            }
        }
    }
}

struct CollectionDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionDetailedView(collection: Collection.test)
                .environmentObject(CollectionDetailViewModel())
                .environmentObject(AppData())
                .environmentObject(AppState())
        }
    }
}


// MARK: - Variables

extension CollectionDetailedView {
    
    private var collectionBlocks: some View {
        ForEach($collection.blocks) { $block in
            let wreck = appData.wrecks.first(where: { $0.id == UUID(uuidString: block.wreckID ?? "") })
            BlockView(block: block, wreck: wreck)
                .padding(.top)
            if appState.authorizedUser == collection.creator || appState.authorizedUser?.role == "moderator" {
                HStack(spacing: 5) {
                    Button(role: .destructive) {
                        Task { await delete(block: block) }
                    } label: { deleteBlockButton }
                    Color.primary.frame(width: 2, height: 50)
                    NavigationLink {
                        AddUpdateBlockView(collection: collection,
                                           block: block,
                                           blockName: block.title,
                                           blockNumber: block.number,
                                           blockWreck: wreck,
                                           blockDescription: block.description)
                    } label: { editBlockButton }
                }
                .background(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(lineWidth: 2))
                .padding(.horizontal)
            }
        }
    }
    
    private var addBlockButton: some View {
        NavigationLink {
            AddUpdateBlockView(collection: collection, block: nil)
        } label: {
            HStack {
                Text("Create block")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .font(.headline.weight(.bold))
            .foregroundColor(.accentColor)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(lineWidth: 2))
            .foregroundColor(.primary)
            .padding()
        }
    }
    
    private var deleteBlockButton: some View {
        HStack {
            Image(systemName: "trash")
            Spacer()
            Text("Delete")
        }
        .padding()
        .font(.headline)
    }
    
    private var editBlockButton: some View {
        HStack {
            Text("Edit")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .font(.headline)
    }
}
