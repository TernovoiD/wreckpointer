//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

@MainActor
final class MapViewModel: ObservableObject {
    
//    @Published var mapRegion: MKCoordinateRegion
//    @Published var selectedWreck: Wreck?
    
    // Filter options
    @Published var textToSearch: String = ""
    @Published var minimumDateFilter: Date = Date()
    @Published var maximumDateFilter: Date = Date()
    @Published var wreckTypeFilter: WreckTypes?
    @Published var wreckCauseFilter: WreckCauses?
    @Published var wreckDiverOnlyFilter: Bool = false
    
//    init() {
//        let mapCoordinateCenter = CLLocationCoordinate2D(latitude: 40, longitude: -30)
//        let mapCoordinateSpan = MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80)
//        let mapCoordinateRegion = MKCoordinateRegion(center: mapCoordinateCenter, span: mapCoordinateSpan)
//        self.mapRegion = mapCoordinateRegion
//    }
    
//    func changeMapRegion(latitude: Double, longitude: Double) {
//        mapRegion.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        if abs(latitude) > 70 {
//            mapRegion.span = MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
//        }
//    }
    
//    func searched(wrecks: [Wreck]) -> [Wreck] {
//        if !textToSearch.isEmpty {
//            return wrecks.filter({ $0.name.lowercased().contains(textToSearch.lowercased()) })
//        } else {
//            return [ ]
//        }
//    }
    
    func filtered(wrecks: [Wreck]) -> [Wreck] {
        var filteredWrecks = wrecks
        
//        if !textToSearch.isEmpty {
//            return wrecks.filter({ $0.name.lowercased().contains(textToSearch.lowercased()) })
//        }
        
//        filteredWrecks = filteredWrecks.filter({
//            if let dateOfLoss = $0.dateOfLoss {
//                return dateOfLoss >= minimumDateFilter && dateOfLoss <= maximumDateFilter
//            } else {
//                return false
//            }
//        })
        
//        if wreckTypeFilter != .all {
//            filteredWrecks = filteredWrecks.filter({ $0.type == wreckTypeFilter.rawValue })
//        }
//        
//        if wreckCauseFilter != .all {
//            filteredWrecks = filteredWrecks.filter({ $0.cause == wreckCauseFilter.rawValue })
//        }
//        
//        if wreckDiverOnlyFilter {
//            filteredWrecks = filteredWrecks.filter({ $0.isWreckDive == true })
//        }
        
        return filteredWrecks
    }
}
