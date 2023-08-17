//
//  MapFilter.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapFilter: View {
    
    @StateObject private var viewModel = MapFilterViewModel()
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var appData: AppData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            openFilterMenuButton
            if appState.activeUIElement == .mapFilter {
                Divider()
                Toggle("Filter by date", isOn: $appData.filterByDate.animation(.easeInOut))
                Toggle("Filter by type", isOn: $appData.filterByType.animation(.easeInOut))
                Toggle("Filter by cause", isOn: $appData.filterByCause.animation(.easeInOut))
                Toggle("Wreck dives only", isOn: $appData.showWreckDivesOnly)
                if appData.filterByType || appData.filterByCause || appData.filterByDate {
                    Divider()
                }
                if appData.filterByDate {
                    minimumDatePicker
                    maximumDatePicker
                }
                if appData.filterByType {
                    wreckTypePicker
                }
                if appData.filterByCause {
                    wreckCausePicker
                }
            }
        }
        .onChange(of: appData.filterByDate, perform: { newValue in setMinimumDate(newValue: newValue) })
        .font(.headline)
        .padding()
        .accentColorBorder()
    }
    
    private func setMinimumDate(newValue: Bool) {
        if newValue {
            appData.minimumDate = viewModel.minimumDateOfLossDate(forWrecks: appData.wrecks)
        }
    }
}

struct MapFilter_Previews: PreviewProvider {
    static var previews: some View {
        MapFilter()
            .environmentObject(MapFilterViewModel())
            .environmentObject(AppState())
            .environmentObject(AppData())
    }
}


// MARK: - Variables

extension MapFilter {
    
    private var openFilterMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                appState.activate(element: appState.activeUIElement == .mapFilter ? .none : .mapFilter)
            }
        } label: {
            if appState.activeUIElement == .mapFilter {
                Label("Filter", systemImage: "xmark")
            } else {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 35, height: 35)
                    .font(.title2)
                    .bold()
            }
        }
    }
    
    private var wreckTypePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $appData.wreckType) {
                ForEach(WreckTypesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
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
            Picker("Wreck type", selection: $appData.wreckCause) {
                ForEach(WreckCausesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var minimumDatePicker: some View {
        DatePicker("From", selection: $appData.minimumDate, displayedComponents: .date)
            .datePickerStyle(.compact)
    }
    
    private var maximumDatePicker: some View {
        DatePicker("To", selection: $appData.maximumDate, displayedComponents: .date)
            .datePickerStyle(.compact)
    }
}
