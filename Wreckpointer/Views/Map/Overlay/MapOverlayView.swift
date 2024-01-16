//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @FocusState private var searchFieldSelected: Bool
    @ObservedObject var map: MapViewModel
    
    var body: some View {
        VStack {
            VStack {
                if let wreck = map.selectedWreck {
                    SelectedWreckView(wreck: wreck)
                        .coloredBorder(color: .primary)
                        .padding(12)
                } else if map.activeUIElement == .search {
                    searchPlate
                        .coloredBorder(color: .primary)
                        .padding(12)
                } else if map.activeUIElement == .filter {
                    filterPlate
                        .coloredBorder(color: .primary)
                        .padding(12)
                } else {
                    placeholder
                }
            }
            .background()
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 7)
            Spacer()
        }
        .padding()
        .onChange(of: map.activeUIElement, perform: { element in
            if element == .none {
                searchFieldSelected = false
            }
        })
    }
    
    private var placeholder: some View {
        HStack {
            Button(action: { 
                activate(element: .search)
                searchFieldSelected = true
            }, label: {
                Color.clear.overlay {
                    Label("Search", systemImage: "magnifyingglass")
                }
            })
            Color.gray
                .frame(maxWidth: 1, maxHeight: 30)
            Button(action: { activate(element: .filter) }, label: {
                Color.clear.overlay {
                    Label("Filter", systemImage: "slider.horizontal.2.square")
                }
            })
        }
        .frame(maxHeight: 50)
        .foregroundStyle(.secondary)
    }
    
    private var searchPlate: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("RMS Titanic", text: $map.textToSearch)
                    .focused($searchFieldSelected)
                    .submitLabel(.search)
                    .autocorrectionDisabled(true)
                Button(action: { }, label: {
                    Image(systemName: "xmark")
                        .font(.headline.bold())
                        .foregroundStyle(Color.primary)
                })
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            RoundedRectangle(cornerRadius: 1)
                .frame(maxHeight: 2)
            List {
                ForEach(map.searchedWrecks) { wreck in
                    Button {
                        map.selectedWreck = wreck
                    } label: {
                        WreckRowView(wreck: wreck)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .frame(maxHeight: 200)
        }
    }
    
    private var filterPlate: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                wreckTypePicker
                wreckCausePicker
                Toggle("Wreck dives only", isOn: $map.wreckDiverOnlyFilter)
                Toggle("Filter by date", isOn: $map.filterByDate.animation())
                if map.filterByDate {
                    DatePicker("From", selection: $map.minimumDateFilter, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    DatePicker("To", selection: $map.maximumDateFilter, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
            .padding()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 1)
                    .frame(maxHeight: 2)
                Button(action: { clearFilter() }, label: {
                    Color.clear
                        .overlay {
                            Text("Clear")
                                .font(.headline.bold())
                        }
                        .frame(maxHeight: 40)
                })
            }
        }
    }
    
    private func clearFilter() {
        withAnimation {
            map.clearFilter()
        }
    }
    
    private var wreckTypePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $map.wreckTypeFilter) {
                Text("All")
                    .tag(WreckTypes?.none)
                ForEach(WreckTypes.allCases) { type in
                    Text(type.description)
                        .tag(WreckTypes?.some(type))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var wreckCausePicker: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck type", selection: $map.wreckCauseFilter) {
                Text("All")
                    .tag(WreckCauses?.none)
                ForEach(WreckCauses.allCases) { cause in
                    Text(cause.description)
                        .tag(WreckCauses?.some(cause))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func activate(element: MapUIElements) {
        withAnimation(.spring) {
            map.activeUIElement = element
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color.white, Color.blue,Color.green], startPoint: .topTrailing, endPoint: .bottomLeading)
            .blur(radius: 10)
            .ignoresSafeArea()
        MapOverlayView(map: MapViewModel())
    }
}
