//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @FocusState private var searchFieldSelected: Bool
    @Binding var activeUIElement: MapUIElement?
    @Binding var mapSelectedWreck: Wreck?
    @Binding var filteredWrecks: [Wreck]
    
    @Binding var textToSearch: String
    @Binding var minimumDateFilter: Date
    @Binding var maximumDateFilter: Date
    @Binding var wreckTypeFilter: WreckTypes?
    @Binding var wreckCauseFilter: WreckCauses?
    @Binding var wreckDiverOnlyFilter: Bool
    
    var body: some View {
        VStack {
            VStack {
                if activeUIElement == .search {
                    searchPlate
                        .coloredBorder(color: .primary)
                        .padding(12)
                } else if activeUIElement == .filter {
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
        
        //    private var searchedWrecksList: some View {
        //
        //    }
        
        //    private func dismissSearch() {
        //        viewModel.textToSearch = ""
        //        searchFieldSelected = false
        //    }
        
    }
    
    var placeholder: some View {
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
    
    var searchPlate: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("RMS Titanic", text: $textToSearch.animation(.easeInOut))
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
                .frame(maxHeight: 1)
            List {
                ForEach($filteredWrecks) { $wreck in
                    Button {
                        mapSelectedWreck = wreck
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
    
    var filterPlate: some View {
        VStack(alignment: .leading, spacing: 5) {
            DatePicker("From", selection: $minimumDateFilter, displayedComponents: .date)
                .datePickerStyle(.compact)
            DatePicker("To", selection: $maximumDateFilter, displayedComponents: .date)
                .datePickerStyle(.compact)
            wreckTypePicker
            wreckCausePicker
            Toggle("Wreck dives only", isOn: $wreckDiverOnlyFilter)
        }
        .padding()
    }
    
    var wreckTypePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $wreckTypeFilter) {
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
    
    var wreckCausePicker: some View {
        HStack {
            Text("Cause")
            Spacer()
            Picker("Wreck type", selection: $wreckCauseFilter) {
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
    
    private func activate(element: MapUIElement) {
        withAnimation(.spring) {
            activeUIElement = element
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color.white, Color.blue,Color.green], startPoint: .topTrailing, endPoint: .bottomLeading)
            .blur(radius: 10)
            .ignoresSafeArea()
        MapOverlayView(activeUIElement: .constant(.search),
                       mapSelectedWreck: .constant(nil),
                       filteredWrecks: .constant([Wreck.test, Wreck.test, Wreck.test, Wreck.test, Wreck.test]),
                       textToSearch: .constant(""),
                       minimumDateFilter: .constant(Date()),
                       maximumDateFilter: .constant(Date()),
                       wreckTypeFilter: .constant(nil),
                       wreckCauseFilter: .constant(nil),
                       wreckDiverOnlyFilter: .constant(false))
    }
}
