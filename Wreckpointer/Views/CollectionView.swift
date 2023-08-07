//
//  CollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionView: View {
    
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
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
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .neonField(light: true)
    }
    
    var collectionImage: some View {
        ImageView(imageData: .constant(collection.image))
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .frame(maxWidth: 50, maxHeight: 50)
    }
    
    var collectionTitle: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(collection.title)
                .font(.title3)
                .bold()
            Text("Created: \(collection.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "unknown")")
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

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        
        let collection: Collection = Collection(id: UUID(uuidString: "collection1"), title: "Aircraft carriers", description: "Collection abount aircraft carriers", image: nil, createdAt: Date(), updatedAt: Date(), blocks: [], approved: true)
        
        CollectionView(collection: collection)
    }
}
