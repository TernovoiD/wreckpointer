//
//  EditWreckInfoView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 19.01.2024.
//

import SwiftUI

private enum FocusedField {
    case lossOfLife, displacement, depth
}

struct EditWreckInfoView: View {
    
    @ObservedObject var viewModel: EditWreckViewModel
    @FocusState private var focusedField: FocusedField?
    @Binding var moderator: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                info
                    .padding(.top)
                    .background()
                    .onTapGesture {
                        focusedField = .none
                    }
                Divider()
                    .padding(.vertical)
                typePicker
                causePicker
                if moderator {
                    Toggle("Approved", isOn: $viewModel.isApproved)
                }
                Toggle("Wreck dive", isOn: $viewModel.isWreckDive)
                datePicker
            }
            .padding(.horizontal)
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var info: some View {
        VStack {
            HStack {
                Text("Displacement")
                TextField("52310", text: $viewModel.displacement)
                    .onChange(of: viewModel.displacement, perform: { value in
                        viewModel.displacement = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .displacement)
                    .background()
                    .onTapGesture {
                        focusedField = .displacement
                    }
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
                    .background()
                    .onTapGesture {
                        focusedField = .depth
                    }
                Text("ft")
            }
            HStack {
                Text("Loss of life")
                TextField("1500", text: $viewModel.lossOfLive)
                    .onChange(of: viewModel.lossOfLive, perform: { value in
                        viewModel.lossOfLive = value.filterWithRegEx(pattern: "[0-9]{1,6}")
                    })
                    .padding()
                    .coloredBorder(color: .primary)
                    .focused($focusedField, equals: .lossOfLife)
                    .background()
                    .onTapGesture {
                        focusedField = .lossOfLife
                    }
            }
        }
    }
    
    private var typePicker: some View {
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
    
    private var causePicker: some View {
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
    
    private var datePicker: some View {
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
}

#Preview {
    NavigationView {
        EditWreckInfoView(viewModel: EditWreckViewModel(), moderator: .constant(true))
    }
}
