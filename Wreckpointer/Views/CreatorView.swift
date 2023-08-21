//
//  CreatorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.08.2023.
//

import SwiftUI

struct CreatorView: View {
    
    @State var creator: User
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Creator")
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Color.primary
                .frame(maxHeight: 15)
            HStack {
                Spacer()
                Text(creator.username ?? "unknown")
                    .font(.system(size: 30, weight: .black, design: .serif))
                accountImage
            }
            .padding(.horizontal)
            Text(creator.bio ?? "unknown")
                .font(.headline)
                .padding()
        }
        .padding(.top, 40)
    }
}

struct CreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorView(creator: User.test)
    }
}

// MARK: - Variables

extension CreatorView {
    
    var accountImage: some View {
        VStack {
            if let image = creator.image,
               let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .frame(width: 25)
        .clipShape(Circle())
        .background(Circle().stroke(lineWidth: 3).foregroundColor(.accentColor))
    }
    
}
