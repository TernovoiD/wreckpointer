//
//  CollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionView: View {
    
    @EnvironmentObject var collections: Collections
    @State var collection: Collection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center) {
                collectionImage
                collectionTitle
                Spacer()
                numberOfWrecks
            }
            if collection.description != "" {
                collectionInfo
            }
        }
        .onChange(of: collections.all) { collections in
            if let updatedCollection = collections.first(where: { $0.id == collection.id }) {
                self.collection = updatedCollection
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: Collection.test)
            .environmentObject(Collections())
            .padding()
            .background(Color.gray.opacity(0.15))
    }
}


// MARK: - Variables

extension CollectionView {
    
    var collectionImage: some View {
        ImageView(imageData: .constant(collection.image))
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .frame(maxWidth: 40)
    }
    
    var collectionTitle: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(collection.title)
                .font(.title3)
                .bold()
            Text("Creator: \(collection.creator?.username ?? "unknown")")
                .font(.subheadline)
        }
    }
    
    var numberOfWrecks: some View {
        Text("\(collection.blocks.count)")
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.accentColor)
            .padding(.horizontal)
    }
    
    var collectionInfo: some View {
        Text(collection.description)
            .font(.caption2)
            .frame(maxHeight: 40)
    }
}
