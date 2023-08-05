//
//  AddUpdateBlockView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.07.2023.
//

import SwiftUI

struct AddUpdateBlockView: View {
    
    @EnvironmentObject var collectionVM: CollectionsViewModel
    @FocusState var selectedField: FocusText?
    @State var selectedImageData: Data? = nil
    @State var imageURL: URL? = nil
    
    // Block
    @State var blockID: UUID?
    @State var blockTitle: String = ""
    @State var blockDescription: String = ""
    @State var wreck: Wreck?
    
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
                .padding(.top, 10)
            descriptionTextEditor
            NavigationLink {
                WrecksListView(selectedWreck: $wreck)
            } label: {
                wreckPanel
            }

        }
        .navigationTitle("Block")
    }
    
    var titleTextField: some View {
        TextField("Block name", text: $blockTitle)
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
    
    var wreckPanel: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.square")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 50, maxHeight: 50)
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            VStack(alignment: .leading, spacing: 0) {
                Text(wreck?.title ?? "No wreck selected")
                if wreck != nil {
                    Text("Date of loss: " + (wreck?.dateOfLoss?.formatted() ?? "unknown"))
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(0.5, contentMode: .fit)
                .frame(maxHeight: 30)
                .foregroundColor(.accentColor)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
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
        
        AddUpdateBlockView()
            .environmentObject(collectionsViewModel)
    }
}
