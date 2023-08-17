//
//  DoubleExtension.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.08.2023.
//

import Foundation

extension Double {
    var metersToFeet: Double {
        self * 3.2808399
    }
    var feetToMeters: Double {
        self / 3.2808399
    }
}