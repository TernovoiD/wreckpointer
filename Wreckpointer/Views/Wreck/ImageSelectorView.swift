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
    // Warning
    @State var warning: Bool = false
    
    
    var body: some View {
        photosPicker
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
    
    private var photosPicker: some View {
        PhotosPicker(selection: $selectedImage, photoLibrary: .shared()) {
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            } else {
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Color.secondary.opacity(0.6)
            .overlay {
                Text("Select image")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
    }
    
    private var image: some View {
        VStack {
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
            } else {
                placeholder
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
                if data.count > 200000 {
                    warning = true
                    selectedImage = nil
                } else {
                    selectedImageData = data
                }
            }
            imageWeight = Double(selectedImageData?.count ?? 0)
        }
    }
}
