//
//  MapFilterView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapFilterView: View {
    
    @ObservedObject var viewModel: MapViewModel
    @State var isActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            DatePicker("From", selection: $viewModel.minimumDateFilter, displayedComponents: .date)
                .datePickerStyle(.compact)
            DatePicker("To", selection: $viewModel.maximumDateFilter, displayedComponents: .date)
                .datePickerStyle(.compact)
            WreckTypePickerView(selection: $viewModel.wreckTypeFilter, enableAllCase: true)
            WreckCausePickerView(selection: $viewModel.wreckCauseFilter, enableAllCase: true)
            Toggle("Wreck dives only", isOn: $viewModel.wreckDiverOnlyFilter)
        }
        .padding()
        .coloredBorder(color: .gray)
    }
}
    
//    private func setMinimumDate(newValue: Bool) {
//        if newValue {
//            appData.minimumDate = viewModel.minimumDateOfLossDate(forWrecks: appData.wrecks)
//        }
//    }
#Preview {
    MapFilterView(viewModel: MapViewModel())
        .environmentObject(MapViewModel())
        .padding(.horizontal)
}
