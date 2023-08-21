//
//  AddUpdateWreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct AddUpdateWreck: View {
    
    @AppStorage("showFeetUnits") private var showFeetUnits: Bool = true
    @StateObject private var viewModel = AddUpdateWreckViewModel()
    @EnvironmentObject private var appData: AppData
    @EnvironmentObject private var appState: AppState
    @FocusState private var selectedField: FocusText?
    @Environment(\.dismiss) private var dismiss
    let wreck: Wreck?
    
    @State var wreckDive: Bool = false
    @State var image: Data?
    @State var title: String = ""
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var northLatitude: Bool = true
    @State var eastLongitude: Bool = true
    @State var feetUnits: Bool = true
    @State var depth: String = ""
    @State var type: WreckTypesEnum = .unknown
    @State var cause: WreckCausesEnum = .unknown
    @State var dateOfLoss: Date = Date()
    @State var dateOfLossKnown: Bool = false
    @State var description: String = ""
    
    enum FocusText {
        case title
        case latitude
        case longitude
        case depth
        case info
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            PhotosPickerView(selectedImageData: $image)
                .background()
                .onTapGesture {
                    selectedField = .none
                }
            VStack(spacing: 10) {
                titleTextField
                latitudeTextField
                longitudeTextField
                depthTextField
                infoTextEditor
                typeSelector
                causeSelector
            }
            .padding(.top, 20)
            .background()
            .onTapGesture { selectedField = .none }
            .padding(.horizontal)
            datePicker
        }
        .toolbar { ToolbarItem { saveButton }}
        .navigationTitle("Wreck")
        .foregroundColor(.purple)
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
    }
    
    var datePicker: some View {
        VStack {
            Toggle(isOn: $wreckDive) { Text("Wreck dive?") }
            dateOfLossPicker
        }
        .padding(.horizontal)
    }
}

struct AddUpdateWreck_Previews: PreviewProvider {
    static var previews: some View {
        AddUpdateWreck(wreck: Wreck.test)
            .environmentObject(AddUpdateWreckViewModel())
            .environmentObject(AppData())
            .environmentObject(AppState())
    }
}

    // MARK: - Variables

extension AddUpdateWreck {

    var titleTextField: some View {
        TextField("Name of wreck", text: $title)
            .padding()
            .focused($selectedField, equals: .title)
            .neonField(light: selectedField == .title ? true : false)
            .onSubmit {
                selectedField = .latitude
            }
            .onTapGesture {
                selectedField = .title
            }
    }

    var latitudeTextField: some View {
        HStack {
            TextField("Latitude", text: $latitude)
                .padding()
                .focused($selectedField, equals: .latitude)
                .neonField(light: selectedField == .latitude ? true : false)
                .onSubmit {
                    selectedField = .longitude
                }
                .onTapGesture {
                    selectedField = .latitude
                }
            Text(northLatitude ? "N" : "S")
                .frame(width: 20)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    northLatitude.toggle()
                }
        }
    }

    var longitudeTextField: some View {
        HStack {
            TextField("Longitude", text: $longitude)
                .padding()
                .focused($selectedField, equals: .longitude)
                .neonField(light: selectedField == .longitude ? true : false)
                .onSubmit {
                    selectedField = .depth
                }
                .onTapGesture {
                    selectedField = .longitude
                }
            Text(eastLongitude ? "E" : "W")
                .frame(width: 20)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    eastLongitude.toggle()
                }
        }
    }

    var depthTextField: some View {
        HStack {
            TextField("Depth", text: $depth)
                .padding()
                .keyboardType(.numberPad)
                .focused($selectedField, equals: .depth)
                .neonField(light: selectedField == .depth ? true : false)
                .onSubmit {
                    selectedField = .info
                }
                .onTapGesture {
                    selectedField = .depth
            }
            Text(feetUnits ? "Feet" : "Metres")
                .frame(width: 100)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    feetUnits.toggle()
                }
        }
    }

    var typeSelector: some View {
        HStack {
            Text("Type of wreck")
            Spacer()
            Picker("Wreck type", selection: $type) {
                ForEach(WreckTypesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    var causeSelector: some View {
        HStack {
            Text("Cause of wreck")
            Spacer()
            Picker("Wreck type", selection: $cause) {
                ForEach(WreckCausesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    var infoTextEditor: some View {
        VStack(spacing: 0) {
            Text("Information:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.horizontal)
                .padding(.top, 20)
            TextEditor(text: $description)
                .frame(height: 200)
                .focused($selectedField, equals: .info)
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .neonField(light: selectedField == .info ? true : false)
                .shadow(radius: 1)
                .onTapGesture {
                    selectedField = .info
                }
        }
    }

    var dateOfLossPicker: some View {
        VStack {
            Toggle(isOn: $dateOfLossKnown.animation(.easeInOut)) {
                Text("Date of loss?")
            }
            if dateOfLossKnown {
                DatePicker("Date of loss", selection: $dateOfLoss, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
    }
    
    var saveButton: some View {
        Button {
            if viewModel.validForm(title: title, latitude: latitude, longitude: longitude, depth: depth) {
                Task { await save() }
            }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}


// MARK: - Functions

extension AddUpdateWreck {
    
    private func save() async {
        let wreckToSave = getWreck()
        
        if let _ = wreck {
            let updatedWreck = await viewModel.update(wreck: wreckToSave)
            if let updatedWreck {
                appData.wrecks.removeAll(where: { $0.id == updatedWreck.id })
                appData.wrecks.append(updatedWreck)
                appState.select(wreck: updatedWreck)
                dismiss()
            }
        } else {
            let createdWreck = await viewModel.create(wreck: wreckToSave)
            if let createdWreck {
                appData.wrecks.append(createdWreck)
                dismiss()
            }
        }
    }
    
    private func getWreck() -> Wreck {
        let latitudeValue = Double(latitude) ?? 0
        let longitudeValue = Double(longitude) ?? 0
        let depthValue = Double(depth) ?? 0
        
        if var wreckToUpdate = wreck {
            wreckToUpdate.title = title
            wreckToUpdate.image = image
            wreckToUpdate.wreckDive = wreckDive
            wreckToUpdate.cause = cause.rawValue
            wreckToUpdate.type = type.rawValue
            wreckToUpdate.depth = feetUnits ? depthValue.feetToMeters : depthValue
            wreckToUpdate.latitude = northLatitude ? latitudeValue : -latitudeValue
            wreckToUpdate.longitude = eastLongitude ? longitudeValue : -longitudeValue
            wreckToUpdate.dateOfLoss = dateOfLossKnown ? dateOfLoss : nil
            wreckToUpdate.information = description
            
            return wreckToUpdate
        } else {
            return Wreck(cause: cause.rawValue,
                         type: type.rawValue,
                         title: title,
                         image: image,
                         depth: feetUnits ? depthValue.feetToMeters : depthValue,
                         latitude: northLatitude ? latitudeValue : -latitudeValue,
                         longitude: eastLongitude ? longitudeValue : -longitudeValue,
                         wreckDive: wreckDive,
                         dateOfLoss: dateOfLossKnown ? dateOfLoss : nil ,
                         information: description)
        }
    }
}
