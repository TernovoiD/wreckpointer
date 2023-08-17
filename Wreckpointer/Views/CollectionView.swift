//
//  CollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct CollectionView: View {
    
    @Binding var collection: Collection
    
    var body: some View {
        collectionImage
            .overlay { collectionOverlay }
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(collection: .constant(Collection.test))
            .padding(.horizontal)
    }
}



// MARK: - Variables

extension CollectionView {
    
    var collectionOverlay: some View {
        VStack {
            collectionBlocks
                .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
            collectionTitle
        }
        .foregroundColor(.white)
        .shadow(color: .black, radius: 6)
        .padding(.horizontal)
        .padding(.top, 5)
        .padding(.bottom, 10)
    }
    
    var collectionImage: some View {
        ImageView(imageData: .constant(collection.image), placehoder: "warship.armada1")
            .frame(width: .infinity, height: 120)
            .clipped()
    }
    
    var collectionBlocks: some View {
        Text("\(collection.blocks.count)")
            .font(.system(size: 50, weight: .black))
    }
    
    var collectionTitle: some View {
        HStack(spacing: 0) {
            Text(collection.title)
                .font(.title2.weight(.black))
            if collection.approved == true {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
            Spacer()
        }
    }
}
