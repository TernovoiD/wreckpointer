//
//  MapFilter.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 14.07.2023.
//

import SwiftUI

struct MapFilter: View {
    
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            openFilterMenuButton
            if mapVM.openFilter {
                wreckTypePicker
                datePicker
                Toggle("Wreck dives only", isOn: $mapVM.showWreckDivesOnly)
            }
        }
        .padding(mapVM.openFilter ? 15 : 30)
        .background(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(lineWidth: 3))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25,
                                    style: .continuous))
        .foregroundColor(.purple)
        .padding()
        .onTapGesture {
            withAnimation(.easeInOut) {
                mapVM.openFilter = true
                mapVM.openMenu = false
                mapVM.searchIsActive = false
            }
        }
    }
    
    var openFilterMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openFilter.toggle()
                mapVM.openMenu = false
                mapVM.searchIsActive = false
            }
        } label: {
            if mapVM.openFilter {
                Label("Close", systemImage: "xmark")
                    .font(.title3.weight(.black))
            } else {
                Label("Filter", systemImage: "slider.horizontal.3")
                    .font(.title3.weight(.black))
            }
        }
    }
    
    var wreckTypePicker: some View {
        HStack {
            Text("Type of wreck")
            Spacer()
            Picker("Wreck type", selection: $mapVM.wreckType) {
                ForEach(WreckTypesEnum.allCases) { option in
                    Text(String(describing: option))
                }
            }
            .pickerStyle(.menu)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var datePicker: some View {
        HStack {
            DatePicker("From", selection: $mapVM.minimumDate, in: ...mapVM.maximumDate, displayedComponents: .date)
                .datePickerStyle(.compact)
            DatePicker("To", selection: $mapVM.maximumDate, in: mapVM.minimumDate...Date(), displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.leading)
        }
    }
}

struct MapFilter_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckService = WreckService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckService: wreckService, coreDataService: coreDataService)
        
        ZStack {
            Color.clear
                .ignoresSafeArea()
            MapFilter()
                .environmentObject(mapViewModel)
        }
    }
}
