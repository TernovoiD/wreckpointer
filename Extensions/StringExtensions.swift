//
//  StringExtensions.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//
import Foundation

extension String {
    
    func matches(pattern: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    func filterWithRegEx(pattern: String) -> String {
        var result = ""
        
        for character in self {
            var textToTest = result
            textToTest.append(character)
            if textToTest.matches(pattern: pattern) {
                result.append(character)
            }
        }
        
        return result
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.matches(pattern: emailRegEx)
    }
    
    
    var isValidUsername: Bool {
        let usernameRegEx = "^[A-Z0-9a-z_]{3,13}$"
        return self.matches(pattern: usernameRegEx)
    }
    
    var isValidPassword: Bool {
        return self.count >= 6 ? true : false
    }
    
    var isValidName: Bool {
        return self.count >= 5 ? true : false
    }
    
    var isValidWreckName: Bool {
        return self.count >= 3 ? true : false
    }
    
    var isValidLatitude: Bool {
        let latitude = Double(self) ?? 999
        return latitude >= 0 && latitude <= 90 ? true : false
    }
    
    var isValidLongitude: Bool {
        let latitude = Double(self) ?? 999
        return latitude >= 0 && latitude <= 180 ? true : false
    }
    
    var isValidDepth: Bool {
        let depth = Double(self)
        if let _ = depth {
            return true
        } else {
            return false
        }
    }
}
