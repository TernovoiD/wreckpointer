//
//  AddUpdateWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 01.01.2024.
//

import SwiftUI

struct AddUpdateWreckView: View {
    
    private enum FocusedField {
        case name,
             latitudeDegrees,
             latitudeMinutes,
             latitudeSeconds,
             longitudeDegrees,
             longitudeMinutes,
             longitudeSeconds,
             history,
             lossOfLife,
             deadweight,
             depth
    }
    
    @FocusState private var focusedField: FocusedField?
    
    let id: UUID? = nil
    @State var name: String = ""
    @State var type: WreckTypes = .unknown
    @State var cause: WreckCauses = .unknown
    @State var isWreckDive: Bool = false
    @State var dateOfLoss: Date = Date()
    @State var dateOfLossKnown: Bool = false
    @State var lossOfLive: String = ""
    @State var history: String = ""
    @State var deadweight: String = ""
    @State var depth: String = ""
    // Coordinates
    @State var latitudeDegrees: String = ""
    @State var latitudeMinutes: String = ""
    @State var latitudeSeconds: String = ""
    @State var latitudeNorth: Bool = true
    @State var longitudeDegrees: String = ""
    @State var longitudeMinutes: String = ""
    @State var longitudeSeconds: String = ""
    @State var longitudeEast: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Name or coordinates are required, all other information is optional.")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .padding(.bottom)
                Color.primary
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                nameAndCoordinates
                Divider()
                    .padding(.top)
                typePicker
                causePicker
                Toggle("Wreck dive", isOn: $isWreckDive)
                datePicker
                Divider()
                    .padding(.bottom)
                additionalInfo
            }
            .padding(.horizontal)
            .onTapGesture {
                focusedField = .none
            }
        }
        .navigationTitle("Wreck")
        .toolbar {
            Button(action: { }, label: {
                Text("Save")
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
                TextField("41", text: $latitudeDegrees)
                    .onChange(of: latitudeDegrees, perform: { value in
                        latitudeDegrees = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if latitudeDegrees.count == 2 {
                            focusedField = .latitudeMinutes
                        }
                    })
                    .focused($focusedField, equals: .latitudeDegrees)
                    .frame(maxWidth: 35)
                    .degree(symbol: "°")
                TextField("43", text: $latitudeMinutes)
                    .onChange(of: latitudeMinutes, perform: { value in
                        latitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if latitudeMinutes.count == 2 {
                            focusedField = .latitudeSeconds
                        }
                    })
                    .focused($focusedField, equals: .latitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                TextField("57", text: $latitudeSeconds)
                    .onChange(of: latitudeSeconds, perform: { value in
                        latitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if latitudeSeconds.count == 2 {
                            focusedField = .longitudeDegrees
                        }
                    })
                    .focused($focusedField, equals: .latitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
            }
            .padding(10)
            .coloredBorder(color: .primary)
            Button {
                latitudeNorth.toggle()
            } label: {
                Text(latitudeNorth ? "N" : "S")
                    .bold()
                    .frame(maxWidth: 20)
            }
        }
    }
    
    var longitude: some View {
        HStack {
            Text("Longitude")
                .font(.title3.bold())
            Spacer()
            HStack {
                TextField("49", text: $longitudeDegrees)
                    .onChange(of: longitudeDegrees, perform: { value in
                        longitudeDegrees = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if longitudeDegrees.count == 2 {
                            focusedField = .longitudeMinutes
                        }
                    })
                    .focused($focusedField, equals: .longitudeDegrees)
                    .frame(maxWidth: 35)
                    .degree(symbol: "°")
                TextField("56", text: $longitudeMinutes)
                    .onChange(of: longitudeMinutes, perform: { value in
                        longitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if longitudeMinutes.count == 2 {
                            focusedField = .longitudeSeconds
                        }
                    })
                    .focused($focusedField, equals: .longitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                TextField("49", text: $longitudeSeconds)
                    .onChange(of: longitudeSeconds, perform: { value in
                        longitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if longitudeSeconds.count == 2 {
                            focusedField = .none
                        }
                    })
                    .focused($focusedField, equals: .longitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
            }
            .padding(10)
            .coloredBorder(color: .primary)
            Button {
                longitudeEast.toggle()
            } label: {
                Text(longitudeEast ? "E" : "W")
                    .bold()
                    .frame(maxWidth: 20)
            }
        }
    }
    
    var nameAndCoordinates: some View {
        VStack(spacing: 10) {
            TextField("RMS Titanic", text: $name)
                .focused($focusedField, equals: .name)
                .onChange(of: name, perform: { value in
                    name = value.filterWithRegEx(pattern: "[a-z,A-z,0-9]{1,30}")
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
            Picker("Wreck type", selection: $type) {
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
            Picker("Wreck cause", selection: $cause) {
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
            Toggle(isOn: $dateOfLossKnown.animation(.spring), label: {
                Label("Date of loss", systemImage: "calendar")
            })
            if dateOfLossKnown {
                DatePicker("Date", selection: $dateOfLoss, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
    }
    
    var additionalInfo: some View {
        VStack {
            Text("History")
            TextEditor(text: $history)
                .frame(height: 200)
                .padding(10)
                .coloredBorder(color: .primary)
                .focused($focusedField, equals: .history)
            HStack {
                Text("Loss of life")
                TextField("1500", text: $lossOfLive)
                    .onChange(of: lossOfLive, perform: { value in
                        lossOfLive = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .lossOfLife)
                Text("souls")
            }
            HStack {
                Text("Displacement")
                TextField("52310", text: $deadweight)
                    .onChange(of: deadweight, perform: { value in
                        deadweight = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .deadweight)
                Text("tons")
                
            }
            HStack {
                Text("Depth")
                TextField("12500", text: $depth)
                    .onChange(of: depth, perform: { value in
                        depth = value.filterWithRegEx(pattern: "[0-9]{1,5}")
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
//    AddUpdateWreckView(name: "Titanic", type: .passengerShip, cause: .collision, isWreckDive: false, dateOfLoss: Date(), dateOfLossKnown: false, lossOfLive: "1500", history: "Titanic history", deadweight: "13500", depth: "12500", latitudeDegrees: "", latitudeMinutes: "", latitudeSeconds: "", latitudeNorth: false, longitudeDegrees: "", longitudeMinutes: "", longitudeSeconds: "", longitudeEast: false)
    AddUpdateWreckView()
}
