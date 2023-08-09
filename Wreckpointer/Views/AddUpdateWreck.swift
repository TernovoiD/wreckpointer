//
//  AddUpdateWreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct AddUpdateWreck: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    @FocusState var selectedField: FocusText?
    @AppStorage("showFeets") var showFeets: Bool = true
    @State var selectedImageData: Data? = nil
    
    // Wreck
    @State var wreckID: UUID?
    @State var wreckTitle: String = ""
    @State var wreckInfo: String = ""
    @State var wreckLatitude: String = ""
    @State var wreckLongitude: String = ""
    @State var wreckDepth: String = ""
    @State var wreckType: WreckTypesEnum = .other
    @State var wreckCause: WreckCausesEnum = .unknown
    @State var wreckDive: Bool = false
    @State var north: Bool = true
    @State var west: Bool = true
    @State var feets: Bool = true
    
    @State var dateOfLossKnown: Bool = false
    @State var dateOfLoss: Date = Date()
    
    @State var error: String = ""
    
    enum FocusText {
        case title
        case latitude
        case longitude
        case depth
        case info
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                PhotosPickerView(selectedImageData: $selectedImageData)
                    .padding(.top, 80)
                VStack(spacing: 10) {
                    titleTextField
                    latitude
                    longitude
                    depth
                }
                .padding(.horizontal)
                Text("Information:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.horizontal)
                    .padding(.top, 20)
                infoTestEditor
                VStack(spacing: 15) {
                    typeSelector
                    causeSelector
                    Toggle("Wreck dive?", isOn: $wreckDive)
                    dateOfLossPicker
                    formErrorText
                }
                .padding(.horizontal)
                .padding(.leading)
                addUpdateWreckButton
                    .padding(.top)
                    .padding(.bottom, 20)
            }
            .background(.ultraThinMaterial)
            .onTapGesture {
                selectedField = .none
            }
            VStack {
                HStack {
                    CloseButton()
                    Spacer()
                }
                Spacer()
            }
        }
        .foregroundColor(.purple)
        .onChange(of: mapVM.wreckToEdit) { newValue in
            updateView(withNewWreck: newValue)
        }
    }
}

struct AddUpdateWreck_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let authManager = AuthorizationManager()
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wrecksLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(authManager: authManager, httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wrecksLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        AddUpdateWreck()
            .environmentObject(mapViewModel)
    }
}

    // MARK: - Variables

extension AddUpdateWreck {
    
    var titleTextField: some View {
        TextField("Name of wreck", text: $wreckTitle)
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
    
    var latitude: some View {
        HStack {
            TextField("Latitude", text: $wreckLatitude)
                .padding()
                .focused($selectedField, equals: .latitude)
                .neonField(light: selectedField == .latitude ? true : false)
                .onSubmit {
                    selectedField = .longitude
                }
                .onTapGesture {
                    selectedField = .latitude
                }
            Text(north ? "N" : "S")
                .frame(width: 20)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    north.toggle()
                }
        }
    }
    
    var longitude: some View {
        HStack {
            TextField("Longitude", text: $wreckLongitude)
                .padding()
                .focused($selectedField, equals: .longitude)
                .neonField(light: selectedField == .longitude ? true : false)
                .onSubmit {
                    selectedField = .depth
                }
                .onTapGesture {
                    selectedField = .longitude
                }
            Text(west ? "W" : "E")
                .frame(width: 20)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    west.toggle()
                }
        }
    }
    
    var depth: some View {
        HStack {
            TextField("Depth", text: $wreckDepth)
                .padding()
                .focused($selectedField, equals: .depth)
                .neonField(light: selectedField == .depth ? true : false)
                .onSubmit {
                    selectedField = .info
                }
                .onTapGesture {
                    selectedField = .depth
            }
            Text(feets ? "Feets" : "Metres")
                .frame(width: 100)
                .padding()
                .accentColorBorder()
                .onTapGesture {
                    feets.toggle()
                }
        }
    }
    
    var typeSelector: some View {
        HStack {
            Text("Type of wreck")
            Spacer()
            Picker("Wreck type", selection: $wreckType) {
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
            Picker("Wreck type", selection: $wreckCause) {
                ForEach(WreckCausesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var infoTestEditor: some View {
        TextEditor(text: $wreckInfo)
            .frame(height: 200)
            .focused($selectedField, equals: .info)
            .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .neonField(light: selectedField == .info ? true : false)
            .onTapGesture {
                selectedField = .info
            }
            .padding(.horizontal)
    }
    
    var dateOfLossPicker: some View {
        VStack {
            Toggle(isOn: $dateOfLossKnown) {
                Text("Date of loss?")
            }
            if dateOfLossKnown {
                DatePicker("Date of loss", selection: $dateOfLoss)
                    .datePickerStyle(.graphical)
            }
        }
    }
    
    var formErrorText: some View {
        Text(error)
            .font(.callout)
            .glassyFont(textColor: .red)
    }
    
    var addUpdateWreckButton: some View {
        Button {
            if isFormValid {
                createWreck()
            }
        } label: {
            Text(wreckID == nil ? "Create wreck" : "Update wreck")
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.purple)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal)
        }
    }
}

    // MARK: - Functions

extension AddUpdateWreck {
    
    func clearForm() {
        wreckID = nil
        wreckTitle = ""
        wreckLatitude = ""
        wreckLongitude = ""
        wreckDepth = ""
        wreckInfo = ""
        wreckType = WreckTypesEnum.other
        wreckCause = WreckCausesEnum.unknown
        wreckDive = false
        selectedImageData = nil
    }
    
    func showFormError(withText text: String) {
        withAnimation(.easeInOut) {
            error = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation(.easeInOut) {
                error = ""
            }
        }
    }
    
    func updateView(withNewWreck wreck: Wreck?) {
        if let newWreck = wreck {
            wreckID = newWreck.id
            wreckTitle = newWreck.title
            north = newWreck.latitude >= 0 ? true : false
            west = newWreck.longitude <= 0 ? true : false
            wreckLatitude = String(abs(newWreck.latitude))
            wreckLongitude = String(abs(newWreck.longitude))
            if let depth = newWreck.depth {
                wreckDepth = showFeets ? String(Int(depth.metersToFeets)) : String(depth)
            }
            feets = showFeets ? true : false
            wreckInfo = newWreck.information ?? ""
            wreckType = WreckTypesEnum.allCases.first(where: { $0.rawValue == newWreck.type }) ?? WreckTypesEnum.all
            wreckCause = WreckCausesEnum.allCases.first(where: { $0.rawValue == newWreck.cause }) ?? WreckCausesEnum.other
            wreckDive = newWreck.wreckDive
            selectedImageData = newWreck.image
            dateOfLossKnown = newWreck.dateOfLoss == nil ? false : true
            dateOfLoss = newWreck.dateOfLoss == nil ? Date() : dateOfLoss
        } else {
            clearForm()
        }
    }
    
    func createWreck() {
        let wreckType = wreckType == .all ? WreckTypesEnum.other.rawValue : wreckType.rawValue
        let latitudeValue = Double(wreckLatitude) ?? 0
        let longitudeValue = Double(wreckLongitude) ?? 0
        let depthValue = Double(wreckDepth) ?? 0
        let newWreck = Wreck(cause: wreckCause.rawValue,
                             type: wreckType,
                             title: wreckTitle,
                             image: selectedImageData,
                             depth: feets ? depthValue.feetsToMeters : depthValue,
                             latitude: north ? latitudeValue : -latitudeValue,
                             longitude: west ? -longitudeValue : longitudeValue,
                             wreckDive: wreckDive,
                             dateOfLoss: dateOfLossKnown ? dateOfLoss : nil ,
                             information: wreckInfo)
        Task {
            do {
                try await mapVM.create(newWreck)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        clearForm()
                        mapVM.showAddWreckView = false
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
}

    // MARK: - Validation

extension AddUpdateWreck {
    
    var isFormValid: Bool {
        if !wreckTitle.isValidWreckName {
            showFormError(withText: "The name must include at least 3 symbols.")
            return false
        } else if !wreckLatitude.isValidLatitude {
            showFormError(withText: "Latitude error! Latitude ranges between 0 and 90 degrees (North or South).")
            return false
        } else if !wreckLongitude.isValidLongitude {
            showFormError(withText: "Longitude error! Latitude ranges between 0 and 180 degrees (West or East).")
            return false
        } else if !wreckDepth.isValidDepth {
            showFormError(withText: "Depth is incorrect.")
            return false
        } else {
            return true
        }
    }
}
