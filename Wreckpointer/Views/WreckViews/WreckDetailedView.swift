//
//  WreckDetailedView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.03.2023.
//

import SwiftUI

struct WreckDetailedView: View {
    let wreck: Wreck
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                wreckImage
                VStack(alignment: .leading) {
                    HStack {
                        Text(wreck.title)
                            .font(.title.bold())
                            .padding(.bottom)
                        Spacer()
                        NavigationLink {
                            UpdateWreckView(wreck: wreck)
                        } label: {
                            Text("Edit")
                                .font(.title2.bold())
                                .padding(.bottom)
                        }
                    }
                    Text(wreck.description)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: Preview

struct WreckDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        WreckDetailedView(wreck: Wreck.zeroWreck)
    }
}

// MARK: Content

extension WreckDetailedView {
    
    
    private var wreckImage: some View {
        AsyncImage(url: wreck.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image("battleship.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
