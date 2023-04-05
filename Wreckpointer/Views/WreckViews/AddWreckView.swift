//
//  AddWreckView.swift
//  Shipwrecks
//
//  Created by Danylo Ternovoi on 14.03.2023.
//

import SwiftUI

struct AddWreckView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    @State var wreckTitle: String = ""
    @State var wreckdescription: String = ""
    @State var wreckDateOfLoss: Date = Date()
    @State var wreckLongitude: Double = 0
    @State var wreckLatitude: Double = 0
    @State var wreckDepth: Double = 0
    @State private var selectedImageData: Data?
    let collection: WrecksCollection
    
    @FocusState var selectedField: FocusText?
    
    enum FocusText {
        case name
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $selectedImageData, imageURL: .constant(nil))
            VStack(spacing: 10) {
                titleField
                descriptionButton
                dateOfLossPicker
                    .padding(.leading)
                depthPicker
                    .padding(.leading)
            }
            .padding(.horizontal)
            CoordinatesSelectorView(latitude: $wreckLatitude, longitude: $wreckLongitude)
        }
        .navigationTitle("Add")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                saveWreckToolbarButton
            }
        }
    }
}

// MARK: Preview

struct AddWreckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddWreckView(collection: WrecksCollection.zeroCollection)
                .environmentObject(CollectionsViewModel())
        }
    }
}

// MARK: Functions

extension AddWreckView {
    
    func save() {
        collectionsVM.createWreck(withTitle: wreckTitle,
                                  andDescription: wreckdescription,
                                  andDepth: wreckDepth,
                                  andLatitude: wreckLatitude,
                                  andLongitude: wreckLongitude,
                                  andDateOfLoss: wreckDateOfLoss,
                                  andImageData: selectedImageData,
                                  inCollection: collection)
        dismiss()
    }
    
    func clearForm() {
        wreckTitle = ""
        wreckdescription = ""
        wreckDateOfLoss = Date()
        wreckLatitude = 0
        wreckLongitude = 0
        wreckDepth = 0
    }
}

// MARK: Content

extension AddWreckView {
    
    private var titleField: some View {
        TextField("Title", text: $wreckTitle)
            .padding()
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                selectedField = .name
            }
    }
    
    var dateOfLossPicker: some View {
        DatePicker("Date of loss", selection: $wreckDateOfLoss, in: ...Date())
    }
    
    var depthPicker: some View {
        VStack(alignment: .leading) {
            Stepper("Depth: \(Int(wreckDepth))", value: $wreckDepth, in: 0...11000.0, step: 1)
            Slider(value: $wreckDepth, in: 0...11000.0, step: 1)
        }
    }
    
}

// MARK: Buttons

extension AddWreckView {
    
    private var descriptionButton: some View {
        NavigationLink {
            TextEditor(text: $wreckdescription)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal)
                .navigationTitle("Description:")
        } label: {
            Text(wreckdescription.isEmpty ? "Description" : wreckdescription)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    var saveWreckToolbarButton: some View {
        Button {
            save()
        } label: {
            Text("Save")
        }

    }
}
