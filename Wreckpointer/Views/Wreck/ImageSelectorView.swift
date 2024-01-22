//
//  ImageSelectorView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.04.2023.
//

import SwiftUI
import PhotosUI

@available(iOS 16, *)
struct ImageSelectorView: View {
    @State private var selectedImage: PhotosPickerItem?
    @Binding var selectedImageData: Data?
    // Warning
    @State private var warning: Bool = false
    
    
    var body: some View {
        PhotosPicker(selection: $selectedImage, photoLibrary: .shared()) {
            ImageView(imageData: $selectedImageData, placehoder: "warship.sunk")
        }
        .onChange(of: selectedImage) { newItem in
            withAnimation(.easeInOut) {
                updateImage(with: newItem)
            }
        }
        .alert(isPresented: $warning, content: {
            Alert(title: Text("Warning"),
                  message: Text("Image weight must not exceed 0.2MB"),
                  dismissButton: .default(Text("Okay"), action: {
                warning = false
            }))
        })
    }
    
    private func updateImage(with newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                if data.count > 200000 {
                    warning = true
                } else {
                    selectedImageData = data
                }
            }
        }
    }
}
