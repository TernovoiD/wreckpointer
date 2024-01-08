//
//  DoubleExtension.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.08.2023.
//

import Foundation

extension Double {
    var metersToFeet: Double {
        self / 0.3048
    }
    
    var feetToMeters: Double {
        self * 0.3048
    }
    
    func getCoordinates() -> (degrees: String, minutes: String, seconds: String) {
        var min: String = ""
        var sec: String = ""
        let coordinateString = String(fabs(self))
        let array = coordinateString.split(separator: ".")
        let significantDigits = String(array[0].prefix(3))
        let exponentPart = String(array[1])
        
        for char in exponentPart {
            if min.count != 2 {
                min.append(String(char))
            } else if sec.count != 2 {
                sec.append(String(char))
            } else {
                break
            }
        }
        
        return (significantDigits, min, sec)
    }
}
