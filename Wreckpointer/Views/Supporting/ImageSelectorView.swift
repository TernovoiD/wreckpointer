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
    @State var selectedImage: PhotosPickerItem?
    @State var imageWeight: Double = 0
    
    @Binding var selectedImageData: Data?
    
    
    var body: some View {
        photosPicker
            .onChange(of: selectedImage) { newItem in
                withAnimation(.easeInOut) {
                    updateImage(with: newItem)
                }
            }
    }
    
    private var photosPicker: some View {
        PhotosPicker(selection: $selectedImage, photoLibrary: .shared()) {
            if selectedImageData == nil {
                placeholder
            } else {
                image
            }
        }
    }
    
    private var placeholder: some View {
        Color.gray.opacity(0.2)
            .overlay {
                Text("Select image")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
    }
    
    private var image: some View {
        VStack {
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
        }
    }
    
    private var overlay: some View {
        VStack {
            Spacer()
            imageWeightCounter
            .padding(.bottom, 10)
            .padding(.horizontal)
            .background(.regularMaterial)
        }
    }
    
    private var imageWeightCounter: some View {
        HStack {
            Text("Image size:")
            Text("\(imageWeight / 1000000, specifier: "%.2F") MB")
            Spacer()
            if selectedImageData != nil {
                clearButton
            }
        }
    }
    
    private var clearButton: some View {
        Button("Clear") {
            withAnimation(.easeInOut) {
                selectedImageData = nil
                imageWeight = 0
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    private func updateImage(with newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                selectedImageData = data
            }
            imageWeight = Double(selectedImageData?.count ?? 0)
        }
    }
}

#Preview {
    if #available(iOS 16, *) {
        ImageSelectorView(selectedImageData: .constant(nil))
            .padding()
            .frame(height: 200)
    } else {
        Circle()
    }
}
