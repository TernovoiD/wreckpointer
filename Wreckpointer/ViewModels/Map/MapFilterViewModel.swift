//
//  MapFilterViewModel.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class MapFilterViewModel: ObservableObject {
    
    func minimumDateOfLossDate(forWrecks allWrecks: [Wreck]) -> Date {
        var datesArray: [Date] = [ ]
        let wrecks = allWrecks.filter({ $0.dateOfLoss != nil })

        if wrecks.isEmpty {
            return Date()
        } else {
            for wreck in wrecks {
                datesArray.append(wreck.dateOfLoss ?? Date())
            }
            return datesArray.min() ?? Date()
        }
    }
    
//    func maximumDateOfLossDate(forWrecks allWrecks: [Wreck]) -> Date {
//        var datesArray: [Date] = [ ]
//        let wrecks = allWrecks.filter({ $0.dateOfLoss != nil })
//
//        if wrecks.isEmpty {
//            return maximumDate
//        } else {
//            for wreck in wrecks {
//                datesArray.append(wreck.dateOfLoss ?? Date())
//            }
//            return datesArray.min() ?? maximumDate
//        }
//    }
}
