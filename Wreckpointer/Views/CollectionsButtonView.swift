//
//  CollectionsButtonView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.08.2023.
//

import SwiftUI

struct CollectionsButtonView: View {
    
    @AppStorage("visitedCollections") var visitedCollections: Bool = false
    
    var body: some View {
        NavigationLink {
            CollectionsView()
        } label: {
            Text("Collections")
                .frame(height: 35)
                .font(.headline)
                .padding()
                .accentColorBorder()
                .overlay(alignment: .topTrailing) { if !visitedCollections { newLabel } }
        }
    }
    
    var newLabel: some View {
        Text("New!")
            .font(.caption2)
            .bold()
            .padding(3)
            .foregroundColor(.white)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .offset(x: 5, y: -5)
    }
}

struct CollectionsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsButtonView()
    }
}
