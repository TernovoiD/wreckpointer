//
//  PhotosPickerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 02.04.2023.
//

import SwiftUI
import PhotosUI

struct PhotosPickerView: View {
    @State var selectedImage: PhotosPickerItem?
    @State var imageWeight: Double = 0
    
    @Binding var selectedImageData: Data?
    
    
    var body: some View {
        VStack {
            photosPicker
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .onChange(of: selectedImage) { newItem in
                    updateImage(with: newItem)
                }
            imageWeightCounter
        }
        .foregroundColor(.accentColor)
        .padding()
    }
}

// MARK: Preview

struct PhotosPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPickerView(selectedImageData: .constant(nil))
    }
}

// MARK: Functions

extension PhotosPickerView {
    
    private func updateImage(with newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                selectedImageData = data
            }
            imageWeight = Double(selectedImageData?.count ?? 0)
        }
    }
}

// MARK: Content

extension PhotosPickerView {
    
    private var photosPicker: some View {
        PhotosPicker(selection: $selectedImage, photoLibrary: .shared()) {
            if selectedImageData == nil {
                Color.gray.opacity(0.2)
                    .frame(height: 250)
                    .overlay {
                        Text("Add image")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
            } else {
                if let selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    private var imageWeightCounter: some View {
        HStack {
            Text("Image size:")
            Text("\(imageWeight / 1000000, specifier: "%.2F") MB")
            Spacer()
            if selectedImageData != nil {
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
        }
        .font(.headline)
        .padding(.horizontal)
    }
    
//    private var loadedImage: some View {
//        AsyncImage(url: imageURL) { image in
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        } placeholder: {
//            Color.gray.opacity(0.2)
//                .frame(height: 250)
//                .overlay {
//                    Text("Add image")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(.ultraThinMaterial)
//                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//                }
//        }
//    }
}
