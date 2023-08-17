//
//  AddUpdateCollection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct AddUpdateCollection: View {
    
    @StateObject private var viewModel = AddUpdateCollectionViewModel()
    @EnvironmentObject private var appData: AppData
    @FocusState private var selectedField: FocusText?
    @Environment(\.dismiss) private var dismiss
    @Binding var collection: Collection
    
    @State var collectionImage: Data?
    @State var collectionName: String = ""
    @State var collectionDescription: String = ""
    
    private enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $collectionImage)
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
    
    private func getCollection() -> Collection {
        if collection.id == nil {
            return Collection(title: collectionName,
                              description: collectionDescription,
                              image: collectionImage)
        } else {
            var updatedCollection = collection
            updatedCollection.title = collectionName
            updatedCollection.description = collectionDescription
            updatedCollection.image = collectionImage
            return updatedCollection
        }
    }
    
    func save() async {
        let collectionToSave = getCollection()
        
        if collectionToSave.id == nil {
            let createdCollection = await viewModel.create(collection: getCollection())
            if let createdCollection {
                appData.collections.append(createdCollection)
                dismiss()
            }
        } else {
            let updatedCollection = await viewModel.update(collection: getCollection())
            if let updatedCollection {
                collection = updatedCollection
                dismiss()
            }
        }
        
    }
}

struct AddUpdateCollection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddUpdateCollection(collection: .constant(Collection.test))
                .environmentObject(AddUpdateCollectionViewModel())
                .environmentObject(AppData())
        }
    }
}

// MARK: - Variables

extension AddUpdateCollection {
    
    var titleTextField: some View {
        TextField("Collection name", text: $collectionName)
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
        TextEditor(text: $collectionDescription)
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
            Task { await save() }
        } label: {
            Text("Save")
                .bold()
        }
    }
}
