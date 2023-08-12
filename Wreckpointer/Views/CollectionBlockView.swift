//
//  CollectionBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionBlockView: View {
    
    @StateObject var viewModel = CollectionBlockViewModel()
    @EnvironmentObject var collections: Collections
    @Binding var collection: Collection
    @Binding var block: Block
    
    var body: some View {
        VStack {
            blockImage
                .contextMenu { deleteBlockButton }
                .padding(.top, 20)
            blockDescription
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func deleteBlock() async {
        let result = await viewModel.delete(block: block, fromCollection: collection)
        if result {
            let updatedCollection = collection.updated(remove: block)
            collections.updateCollection(updatedCollection)
        }
    }
}

struct CollectionBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionBlockView(collection: .constant(Collection.test), block: .constant(Block.test))
            .environmentObject(CollectionBlockViewModel())
            .environmentObject(Collections())
    }
}


// MARK: - Variables

extension CollectionBlockView {
    
    var blockImage: some View {
        ImageView(imageData: $block.image)
            .overlay(alignment: .bottom) {
                HStack {
                    Text("\(Int(block.number)).")
                    Text(block.title)
                    Spacer()
                    NavigationLink {
                        AddUpdateBlockView(originalCollection: $collection, block: block)
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .font(.headline)
                    }
                }
                .font(.title)
                .bold()
                .padding(.horizontal)
                .glassyFont(textColor: .white)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
    }
    
    var blockDescription: some View {
        Text(block.description)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    var deleteBlockButton: some View {
        Button(role: .destructive) {
            Task { await deleteBlock() }
        } label: {
            Label("Delete block", systemImage: "trash.circle")
        }
    }
}
