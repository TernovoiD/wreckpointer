//
//  MapFilter.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapFilter: View {
    
    @StateObject var viewModel = MapFilterViewModel()
    @EnvironmentObject var wrecks: Wrecks
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            openFilterMenuButton
            if state.activeUIElement == .mapFilter {
                Divider()
                Toggle("Filter by date", isOn: $wrecks.filterByDate.animation(.easeInOut))
                Toggle("Filter by type", isOn: $wrecks.filterByType.animation(.easeInOut))
                Toggle("Filter by cause", isOn: $wrecks.filterByCause.animation(.easeInOut))
                Toggle("Wreck dives only", isOn: $wrecks.showWreckDivesOnly)
                if wrecks.filterByType || wrecks.filterByCause || wrecks.filterByDate {
                    Divider()
                }
                if wrecks.filterByDate {
                    HStack {
                        minimumDatePicker
                        maximumDatePicker
                    }
                }
                if wrecks.filterByType {
                    wreckTypePicker
                }
                if wrecks.filterByCause {
                    wreckCausePicker
                }
            }
        }
        .onChange(of: wrecks.filterByDate, perform: { newValue in setMinimumDate(newValue: newValue) })
        .font(.headline)
        .padding()
        .accentColorBorder()
    }
    
    func setMinimumDate(newValue: Bool) {
        if newValue {
            wrecks.minimumDate = viewModel.minimumDateOfLossDate(forWrecks: wrecks.all)
        }
    }
}

struct MapFilter_Previews: PreviewProvider {
    static var previews: some View {
        MapFilter()
            .environmentObject(Wrecks())
            .environmentObject(AppState())
            .environmentObject(MapFilterViewModel())
    }
}


// MARK: - Variables

extension MapFilter {
    
    var openFilterMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                state.activeUIElement = state.activeUIElement == .mapFilter ? .none : .mapFilter
            }
        } label: {
            if state.activeUIElement == .mapFilter {
                Label("Filter", systemImage: "xmark")
            } else {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 35, height: 35)
                    .font(.title2)
                    .bold()
            }
        }
    }
    
    var wreckTypePicker: some View {
        HStack {
            Text("Type")
            Spacer()
            Picker("Wreck type", selection: $wrecks.wreckType) {
                ForEach(WreckTypesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
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
            Picker("Wreck type", selection: $wrecks.wreckCause) {
                ForEach(WreckCausesEnum.allCases) { option in
                    Text(String(describing: option).capitalized)
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var minimumDatePicker: some View {
        DatePicker("From", selection: $wrecks.minimumDate, displayedComponents: .date)
            .datePickerStyle(.compact)
    }
    
    var maximumDatePicker: some View {
        DatePicker("To", selection: $wrecks.maximumDate, displayedComponents: .date)
            .datePickerStyle(.compact)
    }
}
