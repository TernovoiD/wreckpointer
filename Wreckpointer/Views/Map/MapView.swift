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
    @State var presentedWreck: Wreck?
    @State var selectedWreck: Wreck?
    @State var activeUIElement: MapUIElement?
    
    var body: some View {
        NavigationView {
            ZStack {
                iOS14WreckpointerMap(selectedWreck: $selectedWreck)
                    .ignoresSafeArea(edges: .top)
                if activeUIElement != nil || selectedWreck != nil {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea(edges: .top)
                        .onTapGesture {
                            withAnimation(.spring) {
                                activeUIElement = .none
                                selectedWreck = nil
                            }
                        }
                }
                MapOverlayView(activeUIElement: $activeUIElement,
                               mapSelectedWreck: $selectedWreck,
                               textToSearch: $server.textToSearch,
                               filterByDate: $server.filterByDate,
                               minimumDateFilter: $server.minimumDateFilter,
                               maximumDateFilter: $server.maximumDateFilter,
                               wreckTypeFilter: $server.wreckTypeFilter,
                               wreckCauseFilter: $server.wreckCauseFilter,
                               wreckDiverOnlyFilter: $server.wreckDiverOnlyFilter) { clearFilter() }
                .padding(.top)
            }
            .sheet(item: $presentedWreck) { wreck in
                WreckDetailView(wreck: wreck)
            }
            .onChange(of: server.filterByDate, perform: { filterByDate in
                if filterByDate {
                    clearFilterDates()
                }
            })
        }
    }
    
    private var minimumDateOfLossDate: Date {
        var datesArray: [Date] = [ ]
        let wrecks = server.databaseWrecks.filter({ $0.hasDateOfLoss.isValid })
        
        if wrecks.isEmpty {
            return Date()
        } else {
            for wreck in wrecks {
                datesArray.append(wreck.hasDateOfLoss.date)
            }
            return datesArray.min() ?? Date()
        }
    }
    
    private func clearFilter() {
        withAnimation() {
            server.textToSearch = ""
            server.filterByDate = false
            server.wreckTypeFilter = nil
            server.wreckCauseFilter = nil
            server.wreckDiverOnlyFilter = false
        }
    }
    
    private func clearFilterDates() {
        withAnimation() {
            server.maximumDateFilter = Date()
            server.minimumDateFilter = minimumDateOfLossDate
        }
    }
}

#Preview {
    MapView()
        .environmentObject(WreckpointerNetwork())
        .clipShape(RoundedRectangle(cornerRadius: 25))
}
