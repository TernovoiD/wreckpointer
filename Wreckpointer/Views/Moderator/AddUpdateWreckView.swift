//
//  AddUpdateWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 01.01.2024.
//

import SwiftUI

struct AddUpdateWreckView: View {
    
    private enum FocusedField {
        case name, latitudeDegrees, latitudeMinutes, latitudeSeconds, longitudeDegrees, longitudeMinutes, longitudeSeconds, history, lossOfLife, deadweight, depth
    }
    
    @StateObject var viewModel = AddUpdateWreckViewModel()
    @ObservedObject var moderatorVM: ModeratorViewModel
    @FocusState private var focusedField: FocusedField?
    @State var wreck: Wreck
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if #available(iOS 16, *) {
                    ImageSelectorView(selectedImageData: $viewModel.image)
                        .frame(height: 300)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                nameAndCoordinates
                    .padding(.top)
                    .background()
                    .onTapGesture {
                        focusedField = .none
                    }
                Text("Name or coordinates are required, all other information is optional.")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal)
                Divider()
                VStack {
                    VStack {
                        typePicker
                        causePicker
                        Toggle("Approved", isOn: $viewModel.isApproved)
                        Toggle("Wreck dive", isOn: $viewModel.isWreckDive)
                    }
                    .background()
                    .onTapGesture {
                        focusedField = .none
                    }
                    datePicker
                }
                .padding(.horizontal)
                Divider()
                additionalInfo
                    .padding(.horizontal)
            }
            .padding(.horizontal)
        }
        .onAppear(perform: { viewModel.fill(wreck: wreck) })
        .toolbar {
            Button(action: {  
                let wreck = viewModel.getUpdatedWreck()
                Task {
                    await moderatorVM.update(wreck: wreck)
                }
                dismiss()
            }, label: {
                Text("Update")
                    .bold()
            })
        }
    }
}

private extension AddUpdateWreckView {
    
    var latitude: some View {
        HStack {
            Text("Latitude")
                .font(.title3.bold())
            Spacer()
            HStack {
                TextField("41", text: $viewModel.latitudeDegrees)
                    .onChange(of: viewModel.latitudeDegrees, perform: { value in
                        viewModel.latitudeDegrees = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if viewModel.latitudeDegrees.count == 2 {
                            focusedField = .latitudeMinutes
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeDegrees)
                    .frame(maxWidth: 35)
                    .degree(symbol: "°")
                TextField("43", text: $viewModel.latitudeMinutes)
                    .onChange(of: viewModel.latitudeMinutes, perform: { value in
                        viewModel.latitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if viewModel.latitudeMinutes.count == 2 {
                            focusedField = .latitudeSeconds
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                TextField("57", text: $viewModel.latitudeSeconds)
                    .onChange(of: viewModel.latitudeSeconds, perform: { value in
                        viewModel.latitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if viewModel.latitudeSeconds.count == 2 {
                            focusedField = .longitudeDegrees
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
            }
            .padding(10)
            .coloredBorder(color: .primary)
            Button {
                viewModel.latitudeNorth.toggle()
            } label: {
                Color.clear
                    .overlay {
                        Text(viewModel.latitudeNorth ? "N" : "S")
                            .bold()
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
            }
        }
    }
    
    var longitude: some View {
        HStack {
            Text("Longitude")
                .font(.title3.bold())
            Spacer()
            HStack {
                TextField("032", text: $viewModel.longitudeDegrees)
                    .onChange(of: viewModel.longitudeDegrees, perform: { value in
                        viewModel.longitudeDegrees = value.filterWithRegEx(pattern: "[0-9]{1,3}")
                        if viewModel.longitudeDegrees.count == 2 {
                            focusedField = .longitudeMinutes
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeDegrees)
                    .frame(width: 40)
                    .degree(symbol: "°")
                TextField("56", text: $viewModel.longitudeMinutes)
                    .onChange(of: viewModel.longitudeMinutes, perform: { value in
                        viewModel.longitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if viewModel.longitudeMinutes.count == 2 {
                            focusedField = .longitudeSeconds
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                TextField("49", text: $viewModel.longitudeSeconds)
                    .onChange(of: viewModel.longitudeSeconds, perform: { value in
                        viewModel.longitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if viewModel.longitudeSeconds.count == 2 {
                            focusedField = .none
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
            }
            .padding(10)
            .coloredBorder(color: .primary)
            Button {
                viewModel.longitudeEast.toggle()
            } label: {
                Color.clear
                    .overlay {
                        Text(viewModel.longitudeEast ? "E" : "W")
                            .bold()
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
            }
        }
    }
    
    var nameAndCoordinates: some View {
        VStack(spacing: 10) {
            TextField("RMS Titanic", text: $viewModel.name)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .name)
                .onChange(of: viewModel.name, perform: { value in
                    viewModel.name = value.filterWithRegEx(pattern: "[\\sA-Z0-9a-z.-]{1,20}")
                })
                .onSubmit {
                    focusedField = .latitudeDegrees
                }
                .padding()
                .coloredBorder(color: .primary)
            VStack {
                latitude
                longitude
            }
            .padding(.leading)
        }
    }
    
    var typePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $viewModel.type) {
                ForEach(WreckTypes.allCases) { type in
                    Text(type.description)
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var causePicker: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck cause", selection: $viewModel.cause) {
                ForEach(WreckCauses.allCases) { cause in
                    Text(cause.description)
                        .tag(cause)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var datePicker: some View {
        VStack {
            Toggle(isOn: $viewModel.dateOfLossKnown, label: {
                Label("Date of loss", systemImage: "calendar")
            })
            if viewModel.dateOfLossKnown {
                DatePicker("Date", selection: $viewModel.dateOfLoss, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
    }
    
    var additionalInfo: some View {
        VStack {
            Text("History")
            TextEditor(text: $viewModel.history)
                .frame(height: 200)
                .padding(10)
                .coloredBorder(color: .primary)
                .focused($focusedField, equals: .history)
            HStack {
                Text("Loss of life")
                TextField("1500", text: $viewModel.lossOfLive)
                    .onChange(of: viewModel.lossOfLive, perform: { value in
                        viewModel.lossOfLive = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .lossOfLife)
                Text("souls")
            }
            HStack {
                Text("Displacement")
                TextField("52310", text: $viewModel.displacement)
                    .onChange(of: viewModel.displacement, perform: { value in
                        viewModel.displacement = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .deadweight)
                Text("tons")
                
            }
            HStack {
                Text("Depth")
                TextField("12500", text: $viewModel.depth)
                    .onChange(of: viewModel.depth, perform: { value in
                        viewModel.depth = value.filterWithRegEx(pattern: "[0-9]{1,5}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .depth)
                Text("ft")
            }
        }
    }
    
}

#Preview {
    NavigationView {
        AddUpdateWreckView(moderatorVM: ModeratorViewModel(), wreck: Wreck.test)
            .environmentObject(AddUpdateWreckViewModel())
    }
}
