//
//  AddUpdateCollection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct AddUpdateCollection: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @FocusState var selectedField: FocusText?
    @Binding var originalCollection: Collection
    @State var collection: Collection
    @State var error: String = ""
    
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
        .onTapGesture {
            selectedField = .none
        }
        .navigationTitle(collection.id == nil ? "Create collection" : "Update collection")
        .toolbar {
            ToolbarItem {
                saveButton
            }
        }
    }
    
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
            if !collection.title.isEmpty && !collection.description.isEmpty {
                if collection.id == nil {
                    create(collection: collection)
                } else {
                    update(collection: collection)
                }
            }
        } label: {
            Text("Save")
                .bold()
        }
    }
}

struct AddUpdateCollection_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let collectionsService = CollectionsService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
 
        // Init View model
        let collectionsViewModel = CollectionsViewModel(collectionsService: collectionsService)
        
        let collection = Collection(title: "Blank", description: " ", blocks: [])
        
        AddUpdateCollection(originalCollection: .constant(collection), collection: collection)
            .environmentObject(collectionsViewModel)
    }
}

    // MARK: - Functions

extension AddUpdateCollection {
    
    func create(collection: Collection) {
        Task {
            do {
                try await collectionsVM.create(collection: collection)
                DispatchQueue.main.async {
                    originalCollection.title = ""
                    originalCollection.description = ""
                    originalCollection.image = nil
                    originalCollection.blocks = [ ]
                }
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
    
    func update(collection: Collection) {
        Task {
            do {
                var collectionToUpdate = collection
                collectionToUpdate.blocks = [ ]
                try await collectionsVM.update(collection: collectionToUpdate)
                DispatchQueue.main.async {
                    originalCollection.title = collection.title
                    originalCollection.description = collection.description
                    originalCollection.image = collection.image
                }
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
}
