//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 06.01.2024.
//

import Foundation
import SwiftUI
import MapKit

enum MapUIElements {
    case search
    case filter
}

@MainActor
final class MapViewModel: ObservableObject {
    
    var _region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30, longitude: -75),
        span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30))
    
    var region: Binding<MKCoordinateRegion> {
        Binding(
            get: { self._region },
            set: { self._region = $0 }
        )
    }
    
    @AppStorage("showUnapprovedWrecks",store: UserDefaults(suiteName: "group.com.danyloternovoi.Wreckpointer"))
    var showUnapprovedWrecks: Bool = false
    
    @Published var wrecks: [Wreck] = [ ]
    @Published var selectedWreck: Wreck?
    @Published var activeUIElement: MapUIElements?
    //Error handling
    @Published var error: Bool = false
    @Published var errorMessage: String = ""
    // Filter options
    @Published var textToSearch: String = ""
    @Published var filterByDate: Bool = false {
        didSet { if filterByDate { clearFilterDates() }}
    }
    @Published var minimumDateFilter: Date = Date()
    @Published var maximumDateFilter: Date = Date()
    @Published var wreckTypeFilter: WreckTypes?
    @Published var wreckCauseFilter: WreckCauses?
    @Published var wreckDiverOnlyFilter: Bool = false
    
    init() {
        Task {
            await loadWrecks()
        }
    }
    
    var searchedWrecks: [Wreck] {
        var filteredWrecks = wrecks
        
        if !showUnapprovedWrecks {
            filteredWrecks = filteredWrecks.filter({ $0.isApproved == true })
        }
        
        if textToSearch.isEmpty {
            return filteredWrecks
        } else {
            return filteredWrecks.filter({ $0.hasName.lowercased().contains(textToSearch.lowercased())})
        }
    }
    
    var filteredWrecks: [Wreck] {
        var filteredWrecks = wrecks
        
        if filterByDate {
            filteredWrecks = filteredWrecks.filter({
                $0.hasDateOfLoss.isValid
            })
            filteredWrecks = filteredWrecks.filter({
                $0.hasDateOfLoss.date >= minimumDateFilter && $0.hasDateOfLoss.date <= maximumDateFilter
            })
        }
        if wreckTypeFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasType == wreckTypeFilter })
        }
        if wreckCauseFilter != .none {
            filteredWrecks = filteredWrecks.filter({ $0.hasCause == wreckCauseFilter })
        }
        if wreckDiverOnlyFilter {
            filteredWrecks = filteredWrecks.filter({ $0.isWreckDive == true })
        }
        if !showUnapprovedWrecks {
            filteredWrecks = filteredWrecks.filter({ $0.isApproved == true })
        }
        return filteredWrecks
    }
    
    func clearFilter() {
        textToSearch = ""
        filterByDate = false
        wreckTypeFilter = nil
        wreckCauseFilter = nil
        wreckDiverOnlyFilter = false
    }
    
    private var minimumDateOfLossDate: Date {
        var datesArray: [Date] = [ ]
        let validWrecks = wrecks.filter({ $0.hasDateOfLoss.isValid })
        
        if validWrecks.isEmpty {
            return Date()
        } else {
            for wreck in validWrecks {
                datesArray.append(wreck.hasDateOfLoss.date)
            }
            return datesArray.min() ?? Date()
        }
    }
    
    private func clearFilterDates() {
        maximumDateFilter = Date()
        minimumDateFilter = minimumDateOfLossDate
    }
    
    private func showError(withMessage message: String) {
        self.errorMessage = message
        self.error = true
    }
    
    @MainActor
    func loadWrecks() async {
        do {
            guard let url = URL(string: ServerURL.mapWrecks.path) else {
                throw HTTPError.badURL
            }
            let serverData = try await HTTPServer.shared.sendRequest(url: url, HTTPMethod: .GET)
            let serverWrecks = try JSONCoder.shared.decodeArrayFromData(data: serverData) as [Wreck]
            self.wrecks = serverWrecks
        } catch let error {
            showError(withMessage: error.localizedDescription)
        }
    }
}
