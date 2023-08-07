//
//  ImageView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 05.08.2023.
//

import SwiftUI

struct ImageView: View {
    
    @Binding var imageData: Data?
    
    var body: some View {
        if let imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image("battleship.logo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageData: .constant(nil))
    }
}
