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
        VStack(alignment: .leading, spacing: 10) {
            openFilterMenuButton
            if mapVM.openFilter {
                Divider()
                minimumDate
                maximumDate
                Divider()
                wreckTypePicker
                Divider()
                Toggle("Wreck dives only", isOn: $mapVM.showWreckDivesOnly)
            }
        }
        .font(.headline)
        .padding()
        .accentColorBorder()
        .onTapGesture {
            withAnimation(.easeInOut) {
                mapVM.openFilter = true
                mapVM.openSettings = false
                mapVM.openMenu = false
                mapVM.searchIsActive = false
            }
        }
    }
    
    var openFilterMenuButton: some View {
        Button {
            withAnimation(.easeInOut) {
                mapVM.openFilter.toggle()
                mapVM.openSettings = false
                mapVM.openMenu = false
                mapVM.searchIsActive = false
            }
        } label: {
            if mapVM.openFilter {
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
    
    var minimumDate: some View {
        DatePicker("From", selection: $mapVM.minimumDate, in: mapVM.minimumDate...mapVM.maximumDate, displayedComponents: .date)
            .datePickerStyle(.compact)
    }
    
    var maximumDate: some View {
        DatePicker("To", selection: $mapVM.maximumDate, in: mapVM.minimumDate...Date(), displayedComponents: .date)
            .datePickerStyle(.compact)
    }
}

struct MapFilter_Previews: PreviewProvider {
    static var previews: some View {
        
        // Init managers
        let httpManager = HTTPRequestManager()
        let dataCoder = JSONDataCoder()
        
        // Init services
        let wreckLoader = WrecksLoader(httpManager: httpManager, dataCoder: dataCoder)
        let wrecksService = WrecksService(httpManager: httpManager, dataCoder: dataCoder)
        let coreDataService = CoreDataService(dataCoder: dataCoder)
        
        // Init View model
        let mapViewModel = MapViewModel(wreckLoader: wreckLoader, wrecksService: wrecksService, coreDataService: coreDataService)
        
        ZStack {
            Color.clear
                .ignoresSafeArea()
            MapFilter()
                .environmentObject(mapViewModel)
        }
    }
}
