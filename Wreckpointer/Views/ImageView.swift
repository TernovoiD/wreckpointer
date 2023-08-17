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
                .aspectRatio(contentMode: .fill)
        } else {
            Image(placehoder)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageData: .constant(nil))
            .frame(width: 200)
            .frame(height: 200)
    }
}
