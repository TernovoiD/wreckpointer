//
//  MapView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 28.12.2023.
//

import SwiftUI

enum MapUIElement {
    case search
    case filter
}

struct MapView: View {
    
    @EnvironmentObject var server: WreckpointerNetwork
    @StateObject var viewModel = MapViewModel()
    @State var selectedWreck: Wreck?
    @State var activeUIElement: MapUIElement?
    
    var body: some View {
        ZStack {
            iOS14WreckpointerMap(wrecks: $server.wrecks, selectedWreck: $selectedWreck)
                .ignoresSafeArea(edges: .top)
            if activeUIElement != nil {
                Color.black.opacity(0.6)
                    .ignoresSafeArea(edges: .top)
                    .onTapGesture {
                        withAnimation(.spring) {
                            activeUIElement = .none
                        }
                    }
            }
            MapOverlayView(activeUIElement: $activeUIElement,
                           mapSelectedWreck: .constant(nil),
                           filteredWrecks: .constant([ ]),
                           textToSearch: .constant(""),
                           minimumDateFilter: .constant(Date()),
                           maximumDateFilter: .constant(Date()),
                           wreckTypeFilter: .constant(nil),
                           wreckCauseFilter: .constant(nil),
                           wreckDiverOnlyFilter: .constant(false))
            .padding(.top)
        }
    }
    
    private var minimumDateOfLossDate: Date {
        var datesArray: [Date] = [ ]
        let wrecks = server.wrecks.filter({ $0.info?.dateOfLoss != nil })
        
        if wrecks.isEmpty {
            return Date()
        } else {
            for wreck in wrecks {
                datesArray.append(wreck.info?.dateOfLoss ?? Date())
            }
            return datesArray.min() ?? Date()
        }
    }
    
    private func clearFilter() {
        viewModel.textToSearch = ""
        viewModel.minimumDateFilter = Date()
        viewModel.maximumDateFilter = minimumDateOfLossDate
        viewModel.wreckTypeFilter = nil
        viewModel.wreckCauseFilter = nil
        viewModel.wreckDiverOnlyFilter = false
    }
}

#Preview {
    MapView()
        .environmentObject(WreckpointerNetwork())
        .environmentObject(MapViewModel())
        .clipShape(RoundedRectangle(cornerRadius: 25))
}
