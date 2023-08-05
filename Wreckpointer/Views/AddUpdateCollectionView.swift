//
//  AddUpdateCollection.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.07.2023.
//

import SwiftUI

struct AddUpdateCollection: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var collectionVM: CollectionsViewModel
    @FocusState var selectedField: FocusText?
    @State var selectedImageData: Data? = nil
    @State var imageURL: URL? = nil
    
    // Collection
    @State var collectionID: UUID?
    @State var collectionTitle: String = ""
    @State var collectionDescription: String = ""
    @State var collectionBlocks: [Block] = [ ]
    
    @State var error: String = ""
    
    enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $selectedImageData, imageURL: $imageURL)
            titleTextField
                .padding(.horizontal)
            Text("Description:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.top, 20)
            descriptionTextEditor
            if !collectionBlocks.isEmpty {
                blocks
            }
            createCollectionButton
        }
        .navigationTitle("Create collection")
        .toolbar {
            ToolbarItem {
                NavigationLink("Add block", destination: AddUpdateBlockView())
            }
        }
    }
    
    var titleTextField: some View {
        TextField("Collection name", text: $collectionTitle)
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
    
    var createCollectionButton: some View {
        Button {
            if !collectionTitle.isEmpty {
                let collection = Collection(title: collectionTitle,
                                            description: collectionDescription,
                                            image: selectedImageData,
                                            blocks: collectionBlocks)
                create(collection: collection)
            }
        } label: {
            Text("Create collection")
            .padding()
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    var blocks: some View {
        VStack {
            Text("Blocks:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
                .padding(.top, 20)
            List {
                ForEach(collectionBlocks) { block in
                    HStack {
                        Text(block.title)
                        Spacer()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .padding(.horizontal)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
            }
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
        
        AddUpdateCollection()
            .environmentObject(collectionsViewModel)
    }
}

    // MARK: - Functions

extension AddUpdateCollection {
    func create(collection: Collection) {
        Task {
            do {
                try await collectionVM.create(collection: collection)
                collectionID = nil
                collectionTitle = ""
                collectionDescription = ""
                collectionBlocks = [ ]
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
}
