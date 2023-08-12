//
//  CollectionDetailedView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionDetailedView: View {
    
    @EnvironmentObject var collections: Collections
    @EnvironmentObject var state: AppState
    @State var collection: Collection
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            collectionImage
            collectionTitle
            Text(collection.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            ForEach($collection.blocks) { $block in
                CollectionBlockView(collection: $collection, block: $block)
            }
            if state.authorizedUser != nil {
                addBlockButton
            }
        }
        .onAppear { sortBlocks() }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if state.authorizedUser != nil {
                ToolbarItem(placement: .confirmationAction) { updateCollectionButton }
            }
        }
        .onChange(of: collections.all) { collections in
            if let updatedCollection = collections.first(where: { $0.id == collection.id }) {
                self.collection = updatedCollection
            }
        }
    }
    
    func sortBlocks() {
        collection.blocks.sort(by: { $0.number < $1.number })
    }
}

struct CollectionDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionDetailedView(collection: Collection.test)
            .environmentObject(Collections())
            .environmentObject(AppState())
    }
}


// MARK: - Variables

extension CollectionDetailedView {
    
    var collectionImage: some View {
        ImageView(imageData: $collection.image)
            .frame(maxHeight: 450)
            .background(Color.gray.opacity(0.4))
    }
    
    var collectionTitle: some View {
        HStack {
            Text(collection.title)
                .font(.title)
                .bold()
                .glassyFont(textColor: .accentColor)
            Spacer()
            Button {
                
            } label: {
                Label("Report", systemImage: "flag.fill")
                .padding()
                .font(.headline)
                .background(Color.gray.opacity(0.33))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
        .padding()
    }
    
    var addBlockButton: some View {
        NavigationLink {
            AddUpdateBlockView(originalCollection: $collection, block: Block())
        } label: {
            Label("Add block", systemImage: "plus")
                .font(.headline)
                .padding()
                .foregroundColor(.accentColor)
                .background(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke())
        }
    }
    
    var updateCollectionButton: some View {
        NavigationLink {
            AddUpdateCollection(collection: collection)
        } label: {
            Text("Update")
                .bold()
        }
    }
}
