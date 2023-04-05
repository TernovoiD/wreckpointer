//
//  UpdateCollectionView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 24.03.2023.
//

import SwiftUI

struct UpdateCollectionView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    @State var collection: WrecksCollection
    @State private var selectedImageData: Data?
    
    @FocusState var selectedField: FocusText?
    
    enum FocusText {
        case name
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $selectedImageData, imageURL: $collection.imageURL)
            VStack(alignment: .leading, spacing: 15) {
                titleField
                descriptionButton
            }
            .padding(.horizontal)
        }
        .background()
        .onTapGesture {
            selectedField = .none
        }
        .navigationTitle("Edit")
        .toolbar {
            ToolbarItem {
                saveCollectionToolbarButton
            }
        }
    }
}

struct UpdateCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateCollectionView(collection: WrecksCollection.zeroCollection)
                .environmentObject(CollectionsViewModel())
        }
    }
}
 
// MARK: Functions

extension UpdateCollectionView {
    
    private func updateCollection() {
        collectionsVM.updateCollection(newTitle: collection.title, newDescription: collection.description, newImage: selectedImageData, collection: collection)
        dismiss()
    }
}

// MARK: Content

extension UpdateCollectionView {
    
    private var titleField: some View {
        TextField("Title", text: $collection.title)
            .padding()
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                selectedField = .name
            }
    }
}

// MARK: Buttons

extension UpdateCollectionView {
    
    private var saveCollectionToolbarButton: some View {
        Button {
            updateCollection()
        } label: {
            Text("Save")
        }
    }
    
    private var descriptionButton: some View {
        NavigationLink {
            TextEditor(text: $collection.description)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal)
                .navigationTitle("Description:")
        } label: {
            Text(collection.description.isEmpty ? "Description" : collection.description)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}


