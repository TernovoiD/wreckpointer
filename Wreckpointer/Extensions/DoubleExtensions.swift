//
//  DoubleExtensions.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.07.2023.
//

import Foundation

extension Double {
    var metersToFeets: Double {
        self / 3.2808399
    }
    var feetsToMeters: Double {
        self * 3.2808399
    }
}
