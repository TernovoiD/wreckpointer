//
//  AddUpdateWreck.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 15.07.2023.
//

import SwiftUI

struct AddUpdateWreck: View {
    
    @FocusState var selectedField: FocusText?
    @State var selectedImageDate: Data? = nil
    @State var imageURL: URL? = nil
    
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
                PhotosPickerView(selectedImageData: $selectedImageDate, imageURL: $imageURL)
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
                    Toggle("Open for wreck dive?", isOn: $wreckDive)
                }
                .padding(.horizontal)
                .padding(.leading)
                addUpdateWreckButton
                    .padding(.top, 20)
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
    }
    
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
    }
    
    var longitude: some View {
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
    }
    
    var depth: some View {
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
    }
    
    var typeSelector: some View {
        HStack {
            Text("Type of wreck")
            Spacer()
            Picker("Wreck type", selection: $wreckType) {
                ForEach(WreckTypesEnum.allCases) { option in
                    Text(String(describing: option))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var causeSelector: some View {
        HStack {
            Text("Type of wreck")
            Spacer()
            Picker("Wreck type", selection: $wreckCause) {
                ForEach(WreckCausesEnum.allCases) { option in
                    Text(String(describing: option))
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
    
    var addUpdateWreckButton: some View {
        Button {
            
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

struct AddUpdateWreck_Previews: PreviewProvider {
    static var previews: some View {
        AddUpdateWreck()
    }
}
