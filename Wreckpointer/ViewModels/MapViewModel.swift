//
//  MapViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 31.03.2023.
//

import MapKit

@MainActor
final class MapViewModel: ObservableObject {
    
    // Filter options
    @Published var textToSearch: String = ""
    @Published var minimumDateFilter: Date = Date()
    @Published var maximumDateFilter: Date = Date()
    @Published var wreckTypeFilter: WreckTypes?
    @Published var wreckCauseFilter: WreckCauses?
    @Published var wreckDiverOnlyFilter: Bool = false
    
    func searchedWrecks(wrecks: [Wreck]) -> [Wreck] {
        return wrecks.filter({ $0.hasname.lowercased().contains(textToSearch.lowercased()) })
    }
    
    func filtered(wrecks: [Wreck]) -> [Wreck] {
        var filteredWrecks = wrecks
        
//        filteredWrecks = filteredWrecks.filter({
//            if let dateOfLoss = $0.info?.dateOfLoss {
//                return dateOfLoss >= minimumDateFilter && dateOfLoss <= maximumDateFilter
//            } else {
//                return false
//            }
//        })
//        if wreckTypeFilter != .none {
//            filteredWrecks = filteredWrecks.filter({ $0.info?.type == wreckTypeFilter })
//        }
//        if wreckCauseFilter != .none {
//            filteredWrecks = filteredWrecks.filter({ $0.info?.cause == wreckCauseFilter })
//        }
//        if wreckDiverOnlyFilter {
//            filteredWrecks = filteredWrecks.filter({ $0.info?.isWreckDive == true })
//        }
        
        return filteredWrecks
    }
}
