//
//  AddUpdateBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct AddUpdateBlockView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AddUpdateBlockViewModel()
    @EnvironmentObject var collections: Collections
    @FocusState var selectedField: FocusText?
    @Binding var originalCollection: Collection
    @State var block: Block
    
    enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            numberStepper
            VStack {
                PhotosPickerView(selectedImageData: $block.image)
                titleTextField
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top)
                descriptionTextEditor
            }
            .background()
            .onTapGesture {
                selectedField = .none
            }
        }
        .navigationTitle("Block")
        .toolbar{ ToolbarItem{ saveButton } }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func addUpdate() async {
        if block.id == nil {
            let createdBlock = await viewModel.create(block: block, inCollection: originalCollection)
            if let createdBlock {
                let updatedCollection = originalCollection.updated(add: createdBlock)
                collections.updateCollection(updatedCollection)
                dismiss()
            }
        } else {
            let updatedBlock = await viewModel.update(block: block, inCollection: originalCollection)
            if let updatedBlock {
                let updatedCollection = originalCollection.updated(remove: updatedBlock, add: updatedBlock)
                collections.updateCollection(updatedCollection)
                dismiss()
            }
        }
    }
}

struct AddUpdateBlockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddUpdateBlockView(originalCollection: .constant(Collection.test), block: Block.test)
                .environmentObject(Collections())
                .environmentObject(AddUpdateBlockViewModel())
            
        }
    }
}


// MARK: - Variables

extension AddUpdateBlockView {
    
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
        VStack {
            Text("Description:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
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
    
    var saveButton: some View {
        Button {
            Task { await addUpdate() }
        } label: {
            Text("Save")
                .bold()
        }
    }
}
