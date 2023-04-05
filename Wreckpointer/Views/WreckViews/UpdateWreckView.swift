//
//  UpdateWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 24.03.2023.
//

import SwiftUI

struct UpdateWreckView: View {
    @EnvironmentObject var collectionsVM: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    @State var wreck: Wreck
    @State private var selectedImageData: Data?
    @FocusState var selectedField: FocusText?
    
    enum FocusText {
        case name
    }
    
    var body: some View {
        ScrollView {
            PhotosPickerView(selectedImageData: $selectedImageData, imageURL: $wreck.imageURL)
            VStack(spacing: 10) {
                titleField
                descriptionButton
                dateOfLossPicker
                    .padding(.leading)
                depthPicker
                    .padding(.leading)
            }
            .padding(.horizontal)
            CoordinatesSelectorView(latitude: $wreck.latitude, longitude: $wreck.longitude)
                .padding(.top)
        }
        .navigationTitle("Edit")
        .toolbar {
            ToolbarItem {
                saveWreckToolbarButton
            }
        }
    }
}

// MARK: Preview

struct UpdateWreckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateWreckView(wreck: Wreck.zeroWreck)
                .environmentObject(CollectionsViewModel())
        }
    }
}

// MARK: Functions

extension UpdateWreckView {
    
    func save() {
        collectionsVM.updateWreck(newTitle: wreck.title,
                                  newDescription: wreck.description,
                                  newDepth: wreck.depth,
                                  newLatitude: wreck.latitude,
                                  newLongitude: wreck.longitude,
                                  newDateOfLoss: wreck.dateOfLoss,
                                  newImageData: selectedImageData,
                                  wreck: wreck)
        dismiss()
    }
}

// MARK: Content

extension UpdateWreckView {
    
    private var titleField: some View {
        TextField("Title", text: $wreck.title)
            .padding()
            .background(Color.gray.opacity(0.17))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                selectedField = .name
            }
    }
    
    var dateOfLossPicker: some View {
        DatePicker("Date of loss", selection: $wreck.dateOfLoss, in: ...Date())
    }
    
    var depthPicker: some View {
        VStack(alignment: .leading) {
            Stepper("Depth: \(Int(wreck.depth))", value: $wreck.depth, in: 0...11000.0, step: 1)
            Slider(value: $wreck.depth, in: 0...11000.0, step: 1)
        }
    }
}

// MARK: Buttons

extension UpdateWreckView {
    
    var saveWreckToolbarButton: some View {
        Button {
            save()
        } label: {
            Text("Save")
        }
    }
    
    private var descriptionButton: some View {
        NavigationLink {
            TextEditor(text: $wreck.description)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal)
                .navigationTitle("Description:")
        } label: {
            Text(wreck.description.isEmpty ? "Description" : wreck.description)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.17))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}
