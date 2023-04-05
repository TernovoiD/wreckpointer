//
//  AddCollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 24.03.2023.
//

import SwiftUI

struct AddCollectionView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    @State var collectionTitle: String = ""
    @State var collectionDescription: String = ""
    @State private var selectedImageData: Data?
    
    @FocusState var selectedField: FocusText?
    
    enum FocusText {
        case name
    }
    
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $selectedImageData, imageURL: .constant(nil))
            VStack {
                titleField
                descriptionButton
            }
            .padding(.horizontal)
        }
        .navigationTitle(collectionTitle == "" ? "New collection" : collectionTitle)
        .toolbar {
            ToolbarItem {
                saveCollectionToolbarButton
            }
        }
    }
}

struct AddCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
                AddCollectionView()
                    .environmentObject(CollectionsViewModel())
        }
    }
}


// MARK: Functions

extension AddCollectionView {
    private func save() {
        withAnimation(.easeInOut) {
            guard let imageData = selectedImageData else { return }
            collectionsVM.createCollection(withTitle: collectionTitle,
                                           andDescription: collectionDescription,
                                           andImage: imageData)
            dismiss()
        }
    }
}

// MARK: Buttons

extension AddCollectionView {
    
    private var descriptionButton: some View {
        NavigationLink {
            TextEditor(text: $collectionDescription)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal)
                .navigationTitle("Description:")
        } label: {
            Text(collectionDescription.isEmpty ? "Description" : collectionDescription)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    var saveCollectionToolbarButton: some View {
        Button {
            save()
        } label: {
            Text("Save")
        }
    }
}

// MARK: Content

extension AddCollectionView {
    
    private var titleField: some View {
        TextField("Title", text: $collectionTitle)
            .padding()
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                selectedField = .name
            }
    }
}
