//
//  MapOverlayView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 12.08.2023.
//

import SwiftUI

struct MapOverlayView: View {
    
    @EnvironmentObject var server: WreckpointerNetwork
    @EnvironmentObject var store: PurchasesManager
    @FocusState private var searchFieldSelected: Bool
    @Binding var activeUIElement: MapUIElement?
    @Binding var mapSelectedWreck: Wreck?
    
    @Binding var textToSearch: String
    @Binding var filterByDate: Bool
    @Binding var minimumDateFilter: Date
    @Binding var maximumDateFilter: Date
    @Binding var wreckTypeFilter: WreckTypes?
    @Binding var wreckCauseFilter: WreckCauses?
    @Binding var wreckDiverOnlyFilter: Bool
    let filterAction: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                if let wreck = mapSelectedWreck {
                    SelectedWreckView(wreck: wreck)
                        .coloredBorder(color: .primary)
                        .padding(12)
                } else if activeUIElement == .search {
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
            NavigationLink {
                AddUpdateWreckView()
            } label: {
                Color.clear.overlay {
                    Label("Add", systemImage: "plus.circle")
                }
            }
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
                TextField("RMS Titanic", text: $textToSearch)
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
                ForEach(server.searchedWrecks) { wreck in
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
    
    private var filterPlate: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                wreckTypePicker
                wreckCausePicker
                Toggle("Wreck dives only", isOn: $wreckDiverOnlyFilter)
                Toggle("Filter by date", isOn: $filterByDate.animation())
                if filterByDate {
                    DatePicker("From", selection: $minimumDateFilter, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    DatePicker("To", selection: $maximumDateFilter, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
            }
            .padding()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 1)
                    .frame(maxHeight: 2)
                Button(action: { filterAction() }, label: {
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
    
    private var wreckTypePicker: some View {
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
    
    private var wreckCausePicker: some View {
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
        MapOverlayView(activeUIElement: .constant(.filter),
                       mapSelectedWreck: .constant(Wreck.test),
                       textToSearch: .constant(""),
                       filterByDate: .constant(true),
                       minimumDateFilter: .constant(Date()),
                       maximumDateFilter: .constant(Date()),
                       wreckTypeFilter: .constant(nil),
                       wreckCauseFilter: .constant(nil),
                       wreckDiverOnlyFilter: .constant(false),
                       filterAction: { } )
        .environmentObject(WreckpointerNetwork())
        .environmentObject(PurchasesManager())
    }
}
