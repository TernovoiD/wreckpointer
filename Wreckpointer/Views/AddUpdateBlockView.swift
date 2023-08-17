//
//  AddUpdateBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct AddUpdateBlockView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appData: AppData
    @StateObject private var viewModel = AddUpdateBlockViewModel()
    @FocusState private var selectedField: FocusText?
    @Binding var collection: Collection
    @Binding var block: Block
    
    @State var blockName: String = ""
    @State var blockNumber: Int = 1
    @State var blockWreck: Wreck?
    @State var blockDescription: String = ""
    
    private enum FocusText {
        case title
        case description
    }
    
    var body: some View {
        ScrollView {
            VStack {
                titleTextField
                wreckSelector
                descriptionTextEditor
            }
            .padding(.top, 40)
            .background()
            .onTapGesture { selectedField = .none }
            numberStepper
        }
        .navigationTitle("Block")
        .toolbar{ ToolbarItem{ saveButton } }
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func getBlock() -> Block {
        if block.id == nil {
            return Block(title: blockName,
                         number: blockNumber,
                         wreckID: blockWreck?.id?.uuidString,
                         description: blockDescription)
        } else {
            var updatedBlock = block
            updatedBlock.title = blockName
            updatedBlock.number = blockNumber
            updatedBlock.wreckID = blockWreck?.id?.uuidString
            updatedBlock.description = blockDescription
            return updatedBlock
        }
    }
    
    func save() async {
        let blockToSave = getBlock()
        
        if blockToSave.id == nil {
            let createdBlock = await viewModel.create(block: blockToSave, collectionID: collection.id)
            if let createdBlock {
                collection.blocks.append(createdBlock)
                if let index = appData.collections.firstIndex(where: { $0.id == collection.id }) {
                    appData.collections[index].blocks.append(createdBlock)
                }
                dismiss()
            }
        } else {
            let updatedBlock = await viewModel.update(block: blockToSave, collectionID: collection.id)
            if let updatedBlock {
                block = updatedBlock
                if let index = appData.collections.firstIndex(where: { $0.id == collection.id }) {
                    appData.collections[index].blocks.removeAll(where: { $0.id == block.id })
                    appData.collections[index].blocks.append(updatedBlock)
                }
                dismiss()
            }
        }
    }
}

struct AddUpdateBlockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddUpdateBlockView(collection: .constant(Collection.test), block: .constant(Block.test))
                .environmentObject(AddUpdateBlockViewModel())
                .environmentObject(AppData())
        }
    }
}


// MARK: - Variables

extension AddUpdateBlockView {
    
    var numberStepper: some View {
        VStack(alignment: .leading) {
            Stepper("Number: \(Int(blockNumber))", value: $blockNumber, in: 1...100)
                .font(.headline)
            Text("Block number defines an order in which collection blocks will be shown.")
                .font(.caption2)
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
    
    var titleTextField: some View {
        TextField("Block name", text: $blockName)
            .padding()
            .focused($selectedField, equals: .title)
            .neonField(light: selectedField == .title ? true : false)
            .onSubmit {
                selectedField = .description
            }
            .onTapGesture {
                selectedField = .title
            }
            .padding(.horizontal)
    }
    
    var wreckSelector: some View {
        NavigationLink {
            WrecksListView(wreck: $blockWreck)
        } label: {
            HStack {
                Text("Selected wreck: \(blockWreck?.title ?? "none")")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.headline)
            .padding()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
        }
    }
    
    var descriptionTextEditor: some View {
        VStack {
            Text("Description:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.horizontal)
            TextEditor(text: $blockDescription)
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
            Task { await save() }
        } label: {
            Text("Save")
                .bold()
        }
    }
}
