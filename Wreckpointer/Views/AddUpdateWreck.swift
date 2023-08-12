//
//  AddUpdateWreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct AddUpdateWreck: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var wrecks: Wrecks
    @StateObject var viewModel: AddUpdateWreckViewModel = AddUpdateWreckViewModel()
    @AppStorage("showFeetUnits") var showFeetUnits: Bool = true
    @FocusState var selectedField: FocusText?
    @State var wreck: Wreck
    
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var northLatitude: Bool = true
    @State var eastLongitude: Bool = true
    @State var feetUnits: Bool = false
    @State var depth: String = ""
    @State var type: WreckTypesEnum = .unknown
    @State var cause: WreckCausesEnum = .unknown
    @State var dateOfLoss: Date = Date()
    @State var dateOfLossKnown: Bool = false
    @State var additionalInformation: String = ""
    
    init(wreck: Wreck) {
        _wreck = State(initialValue: wreck)
        _latitude = State(initialValue: String(abs(wreck.latitude)))
        _longitude = State(initialValue: String(abs(wreck.longitude)))
        _northLatitude = State(initialValue: wreck.latitude >= 0 ? true : false)
        _eastLongitude = State(initialValue: wreck.longitude >= 0 ? true : false)
        _type = State(initialValue: WreckTypesEnum.allCases.first(where: { $0.rawValue == wreck.type }) ?? WreckTypesEnum.unknown)
        _cause = State(initialValue: WreckCausesEnum.allCases.first(where: { $0.rawValue == wreck.cause }) ?? WreckCausesEnum.unknown)
        _additionalInformation = State(initialValue: wreck.information ?? "")

        if let depth = wreck.depth {
            _depth = State(initialValue: String(depth))
        } else {
            _depth = State(initialValue: "")
        }

        if let date = wreck.dateOfLoss {
            _dateOfLossKnown = State(initialValue: true)
            _dateOfLoss = State(initialValue: date)
        } else {
            _dateOfLossKnown = State(initialValue: false)
            _dateOfLoss = State(initialValue: Date())
        }
    }
    
    enum FocusText {
        case title
        case latitude
        case longitude
        case depth
        case info
    }
    
    var isFormValid: Bool {
        if !wreck.title.isValidWreckName {
            viewModel.showError(withMessage: "The name must include at least 3 symbols.")
            return false
        } else if !latitude.isValidLatitude {
            viewModel.showError(withMessage: "Latitude error! Latitude ranges between 0 and 90 degrees (North or South).")
            return false
        } else if !longitude.isValidLongitude {
            viewModel.showError(withMessage: "Longitude error! Latitude ranges between 0 and 180 degrees (West or East).")
            return false
        } else if !depth.isValidDepth {
            viewModel.showError(withMessage: "Depth is incorrect.")
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            PhotosPickerView(selectedImageData: $wreck.image)
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
            .onTapGesture {
                selectedField = .none
            }
            .padding(.horizontal)
            VStack {
                Toggle(isOn: $wreck.wreckDive) {
                    Text("Wreck dive?")
                }
                dateOfLossPicker
            }
            .padding(.horizontal)
        }
        .toolbar { ToolbarItem { saveButton }}
        .alert(viewModel.errorMessage, isPresented: $viewModel.error) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle(wreck.id == nil ? "Add wreck" : "Update wreck")
        .foregroundColor(.purple)
    }
}

struct AddUpdateWreck_Previews: PreviewProvider {
    static var previews: some View {
        let testWreck = Wreck(cause: "other", type: "all", title: "Wreck", latitude: 30, longitude: 30, wreckDive: false)
        AddUpdateWreck(wreck: testWreck)
            .environmentObject(AddUpdateWreckViewModel())
            .environmentObject(Wrecks())
    }
}

    // MARK: - Variables

extension AddUpdateWreck {

    var titleTextField: some View {
        TextField("Name of wreck", text: $wreck.title)
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
                .keyboardType(.numberPad)
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
                .keyboardType(.numberPad)
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
            TextEditor(text: $additionalInformation)
                .frame(height: 200)
                .focused($selectedField, equals: .info)
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .neonField(light: selectedField == .info ? true : false)
                .onTapGesture {
                    selectedField = .info
                }
        }
        .shadow(radius: 1)
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
            Task { await createUpdate(wreck: getWreck()) }
        } label: {
            Text("Save")
                .font(.headline)
        }
    }
}


// MARK: - Functions

extension AddUpdateWreck {
    
    private func createUpdate(wreck: Wreck) async {
        if wreck.id == nil {
            let createdWreck = await viewModel.create(wreck: wreck)
            if let createdWreck {
                wrecks.all.append(createdWreck)
                dismiss()
            }
        } else {
            let updatedWreck = await viewModel.update(wreck: wreck)
            if let updatedWreck {
                wrecks.all.removeAll(where: { $0.id == updatedWreck.id })
                wrecks.all.append(updatedWreck)
                dismiss()
            }
        }
    }
    
    private func getWreck() -> Wreck {
        let latitudeValue = Double(latitude) ?? 0
        let longitudeValue = Double(longitude) ?? 0
        let depthValue = Double(depth) ?? 0
        
        if wreck.id == nil {
            return Wreck(cause: cause.rawValue,
                         type: type.rawValue,
                         title: wreck.title,
                         image: wreck.image,
                         depth: feetUnits ? depthValue.feetToMeters : depthValue,
                         latitude: northLatitude ? latitudeValue : -latitudeValue,
                         longitude: eastLongitude ? longitudeValue : -longitudeValue,
                         wreckDive: wreck.wreckDive,
                         dateOfLoss: dateOfLossKnown ? dateOfLoss : nil ,
                         information: additionalInformation)
        } else {
            wreck.cause = cause.rawValue
            wreck.type = type.rawValue
            wreck.depth = feetUnits ? depthValue.feetToMeters : depthValue
            wreck.latitude = northLatitude ? latitudeValue : -latitudeValue
            wreck.longitude = eastLongitude ? longitudeValue : -longitudeValue
            wreck.dateOfLoss = dateOfLossKnown ? dateOfLoss : nil
            wreck.information = additionalInformation
            
            return wreck
        }
    }
}
