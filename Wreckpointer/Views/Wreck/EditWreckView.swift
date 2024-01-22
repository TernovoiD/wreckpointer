//
//  EditWreckView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 18.01.2024.
//

import SwiftUI

private enum FocusedField {
    case name, latitudeDegrees, latitudeMinutes, latitudeSeconds, longitudeDegrees, longitudeMinutes, longitudeSeconds
}

struct EditWreckView: View {
    
    @EnvironmentObject var data: WreckpointerData
    @StateObject var viewModel = EditWreckViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: FocusedField?
    @State var wreckID: UUID? = nil
    @State var moderator: Bool = false
    @State var error: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if #available(iOS 16, *) {
                    ImageSelectorView(selectedImageData: $viewModel.image)
                        .scaledToFill()
                }
                nameAndCoordinates
                    .padding()
                Divider()
                history
                .padding()
                .padding(.horizontal)
                Divider()
                wreckInfo
                    .padding()
                Image("ship3")
                    .resizable()
                    .frame(maxHeight: 300)
                
            }
            .navigationTitle(viewModel.name.isEmpty ? "Wreck" : viewModel.name)
            .alert(errorMessage, isPresented: $error) {
                Button("OK", role: .cancel) { }
            }
            .toolbar {
                Button("Save") {
                    if isFormValid() {
                        save()
                    }
                }
                .font(.headline.bold())
            }
            .task {
                if wreckID != nil {
                    await getWreck()
                }
            }
        }
    }
    
    private func isFormValid() -> Bool {
        if viewModel.name.isEmpty {
            showError(withMessage: "Name cannot be empty")
            return false
        } else if viewModel.wreckLatitude == nil {
            showError(withMessage: "Incorrect latitude")
            return false
        } else if viewModel.wreckLongitude == nil {
            showError(withMessage: "Incorrect longitude")
            return false
        } else {
            return true
        }
    }
    
    private func showError(withMessage: String) {
        errorMessage = withMessage
        error = true
    }
    
    private func getWreck() async {
        if !viewModel.updated {
            guard let serverWreck = await data.loadWreck(withID: wreckID) else { return }
            DispatchQueue.main.async {
                self.viewModel.update(serverWreck)
            }
        }
    }
    
    private func save() {
        let wreck = viewModel.getUpdatedWreck()
        Task {
            if wreckID == nil {
                await data.create(wreck: wreck)
            } else {
                await data.update(wreck: wreck)
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationView {
        EditWreckView()
            .environmentObject(WreckpointerData())
            .environmentObject(EditWreckViewModel())
    }
}

private extension EditWreckView {
    
    var wreckInfo: some View {
        NavigationLink {
            EditWreckInfoView(viewModel: viewModel, moderator: $moderator)
        } label: {
            HStack {
                WreckInfoView(wreck: viewModel.getUpdatedWreck())
                    .foregroundStyle(Color.secondary)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
        }

    }
    
    var history: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink {
                EditWreckHistoryView(viewModel: viewModel)
            } label: {
                HStack {
                    Text("History")
                        .font(.title3.bold())
                        .foregroundStyle(Color.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
    
    var nameAndCoordinates: some View {
        VStack(spacing: 10) {
            TextField("RMS Titanic", text: $viewModel.name)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .name)
                .onChange(of: viewModel.name, perform: { value in
                    viewModel.name = value.filterWithRegEx(pattern: "[\\sA-Z0-9a-z.-/]{1,20}")
                })
                .onSubmit {
                    focusedField = .latitudeDegrees
                }
                .background()
                .onTapGesture {
                    focusedField = .name
                }
                .padding()
                .coloredBorder(color: .primary)
            VStack {
                latitude
                longitude
            }
            .padding(.leading)
            .background()
            .onTapGesture {
                focusedField = .none
            }
        }
    }
    
    var latitude: some View {
        HStack {
            Text("Latitude")
                .font(.title3.bold())
            Spacer()
            HStack {
                TextField("41", text: $viewModel.latitudeDegrees)
                    .onChange(of: viewModel.latitudeDegrees, perform: { value in
                        viewModel.latitudeDegrees = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if focusedField == .latitudeDegrees && viewModel.latitudeDegrees.count == 2 {
                            focusedField = .latitudeMinutes
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeDegrees)
                    .frame(maxWidth: 35)
                    .degree(symbol: "°")
                    .background()
                    .onTapGesture {
                        focusedField = .latitudeDegrees
                    }
                TextField("43", text: $viewModel.latitudeMinutes)
                    .onChange(of: viewModel.latitudeMinutes, perform: { value in
                        viewModel.latitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if focusedField == .latitudeMinutes && viewModel.latitudeMinutes.count == 2 {
                            focusedField = .latitudeSeconds
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                    .background()
                    .onTapGesture {
                        focusedField = .latitudeMinutes
                    }
                TextField("57", text: $viewModel.latitudeSeconds)
                    .onChange(of: viewModel.latitudeSeconds, perform: { value in
                        viewModel.latitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if focusedField == .latitudeSeconds && viewModel.latitudeSeconds.count == 2 {
                            focusedField = .longitudeDegrees
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .latitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
                    .background()
                    .onTapGesture {
                        focusedField = .latitudeSeconds
                    }
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
                        if focusedField == .longitudeDegrees && viewModel.longitudeDegrees.count == 3 {
                            focusedField = .longitudeMinutes
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeDegrees)
                    .frame(width: 40)
                    .degree(symbol: "°")
                    .background()
                    .onTapGesture {
                        focusedField = .longitudeDegrees
                    }
                TextField("56", text: $viewModel.longitudeMinutes)
                    .onChange(of: viewModel.longitudeMinutes, perform: { value in
                        viewModel.longitudeMinutes = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if focusedField == .longitudeMinutes && viewModel.longitudeMinutes.count == 2 {
                            focusedField = .longitudeSeconds
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeMinutes)
                    .frame(maxWidth: 35)
                    .degree(symbol: "'")
                    .background()
                    .onTapGesture {
                        focusedField = .longitudeMinutes
                    }
                TextField("49", text: $viewModel.longitudeSeconds)
                    .onChange(of: viewModel.longitudeSeconds, perform: { value in
                        viewModel.longitudeSeconds = value.filterWithRegEx(pattern: "[0-9]{1,2}")
                        if focusedField == .longitudeSeconds && viewModel.longitudeSeconds.count == 2 {
                            focusedField = .none
                        }
                    })
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .longitudeSeconds)
                    .frame(maxWidth: 35)
                    .degree(symbol: "''")
                    .background()
                    .onTapGesture {
                        focusedField = .longitudeSeconds
                    }
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
}
