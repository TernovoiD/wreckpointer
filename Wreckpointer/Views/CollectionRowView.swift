//
//  CollectionRowView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 25.03.2023.
//

import SwiftUI

struct CollectionRowView: View {
    let collection: WrecksCollection
    
    var body: some View {
        HStack(spacing: 10) {
            collectionImage
            VStack(alignment: .leading, spacing: 5) {
                Text(collection.title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.primary)
                Text("Collection")
                    .foregroundColor(.primary)
                
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.17))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
}

struct CollectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionRowView(collection: WrecksCollection.zeroCollection)
            .padding(.horizontal)
    }
}

// MARK: Content

extension CollectionRowView {
    private var collectionImage: some View {
            AsyncImage(url: collection.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } placeholder: {
                Image("battleship.logo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
    }
}
