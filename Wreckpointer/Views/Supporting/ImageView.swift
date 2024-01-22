//
//  ImageView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.08.2023.
//

import SwiftUI

struct ImageView: View {
    
    @Binding var imageData: Data?
    @State var placehoder: String = "warship.sunk"
    
    var body: some View {
        if let imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(placehoder)
                .resizable()
        }
    }
}

#Preview {
    ImageView(imageData: .constant(nil))
        .aspectRatio(contentMode: .fill)
        .frame(width: 350, height: 350)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 15))
}
