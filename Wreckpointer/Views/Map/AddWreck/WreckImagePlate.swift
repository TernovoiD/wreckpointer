//
//  WreckImagePlate.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 09.12.2023.
//

import SwiftUI

struct WreckImagePlate: View {
    
    @Binding var imageData: Data?
    
    var body: some View {
        VStack {
            if #available(iOS 16, *) {
                ImageSelectorView(selectedImageData: $imageData)
            } else {
                iOS15Placeholder
            }
        }
    }
    
    private var iOS15Placeholder: some View {
        Text("Not available")
    }
}

#Preview {
    WreckImagePlate(imageData: .constant(nil))
}
