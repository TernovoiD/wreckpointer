//
//  WreckImagesView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.01.2024.
//

import SwiftUI

struct WreckImagesView: View {
    
    @State var wreckImages: [Data]
    @State var images = ["warship.armada", "warship.armada1", "warship.armada2", "warship.armada3"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                Image(image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            }
        }
        .tabViewStyle(.page)
        .frame(maxHeight: 200)
    }
}

#Preview {
    WreckImagesView(wreckImages: [ ])
}
