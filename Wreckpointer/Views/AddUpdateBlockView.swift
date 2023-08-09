//
//  AddUpdateBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct AddUpdateBlockView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var collectionVM: CollectionsViewModel
    @FocusState var selectedField: FocusText?
    @Binding var originalCollection: Collection
    @State var block: Block
    @State var error: String = ""
    
    enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $block.image)
            numberStepper
                .padding(.bottom)
            titleTextField
                .padding(.horizontal)
                .padding(.bottom)
            Text("Description:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
            descriptionTextEditor
        }
        .onTapGesture {
            selectedField = .none
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    if !block.title.isEmpty {
                        if block.id == nil {
                            create(block: block)
                        } else {
                            update(block: block)
                        }
                    }
                } label: {
                    Text("Save")
                        .bold()
                }

            }
        })
        .navigationTitle("Block")
    }
    
    var titleTextField: some View {
        TextField("Block name", text: $block.title)
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
    
    var numberStepper: some View {
        VStack {
            Stepper("Number: \(Int(block.number))", value: $block.number, in: 1...100)
                .font(.headline)
            Text("Block number defines an order in which collection blocks will be shown.")
                .font(.caption2)
        }
        .padding(.horizontal)
        .padding(.leading)
    }
    
    var descriptionTextEditor: some View {
        TextEditor(text: $block.description)
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
}

struct AddUpdateBlockView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let collectionsService = CollectionsService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
 
        // Init View model
        let collectionsViewModel = CollectionsViewModel(collectionsService: collectionsService)
        
        let collection = Collection(title: "Blank collection", description: "", blocks: [ ])
        let block = Block(title: "Blank", number: 1, description: "")
        
        AddUpdateBlockView(originalCollection: .constant(collection), block: block)
            .environmentObject(collectionsViewModel)
    }
}


// MARK: - Functions

extension AddUpdateBlockView {
    
    func create(block: Block) {
        Task {
            do {
                let createdBlock = try await collectionVM.addBlock(block, toCollection: originalCollection)
                
                DispatchQueue.main.async {
                    originalCollection.blocks.append(createdBlock)
                    originalCollection.blocks.sort(by: { $0.number < $1.number })
                }
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
    
    func update(block: Block) {
        Task {
            do {
                let updatedBlock = try await collectionVM.updateBlock(block, inCollection: originalCollection)
                
                if let index = originalCollection.blocks.firstIndex(where: { $0.id == block.id }) {
                    DispatchQueue.main.async {
                        originalCollection.blocks[index].title = updatedBlock.title
                        originalCollection.blocks[index].description = updatedBlock.description
                        originalCollection.blocks[index].number = updatedBlock.number
                        originalCollection.blocks[index].image = updatedBlock.image
                        originalCollection.blocks.sort(by: { $0.number < $1.number })
                    }
                }
                dismiss()
            } catch let error {
                print(error)
            }
        }
    }
}
