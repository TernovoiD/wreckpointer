//
//  AddUpdateCollection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct AddUpdateCollection: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AddUpdateCollectionViewModel()
    @EnvironmentObject var collections: Collections
    @FocusState var selectedField: FocusText?
    @State var collection: Collection
    
    enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $collection.image)
            titleTextField
                .padding(.horizontal)
            Text("Description:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.top, 20)
            descriptionTextEditor
        }
        .navigationTitle("Collection")
        .onTapGesture { selectedField = .none }
        .toolbar { ToolbarItem { saveButton } }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func addUpdate() async {
        if collection.id == nil {
            let createdCollection = await viewModel.create(collection: collection)
            if let createdCollection {
                collections.updateCollection(createdCollection)
                dismiss()
            }
        } else {
            var collectionToUpdate = collection
            let blocks = collectionToUpdate.blocks
            collectionToUpdate.blocks = [ ]
            let updatedCollection = await viewModel.update(collection: collectionToUpdate)
            if var updatedCollection {
                updatedCollection.blocks = blocks
                collections.updateCollection(updatedCollection)
                dismiss()
            }
        }
    }
}

struct AddUpdateCollection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddUpdateCollection(collection: Collection.test)
                .environmentObject(Collections())
                .environmentObject(AddUpdateCollectionViewModel())
        }
    }
}

// MARK: - Variables

extension AddUpdateCollection {
    
    var titleTextField: some View {
        TextField("Collection name", text: $collection.title)
            .padding()
            .focused($selectedField, equals: .title)
            .neonField(light: selectedField == .title ? true : false)
            .onSubmit {
                selectedField = .description
            }
            .onTapGesture {
                selectedField = .title
            }
    }
    
    var descriptionTextEditor: some View {
        TextEditor(text: $collection.description)
            .frame(height: 200)
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(3)
            .focused($selectedField, equals: .description)
            .neonField(light: selectedField == .description ? true : false)
            .onTapGesture {
                selectedField = .none
            }
            .padding(.horizontal)
    }
    
    var saveButton: some View {
        Button {
            Task { await addUpdate() }
        } label: {
            Text("Save")
                .bold()
        }
    }
}
