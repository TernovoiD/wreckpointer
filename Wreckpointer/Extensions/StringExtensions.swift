//
//  StringExtensions.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 13.07.2023.
//
import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    
    var isValidUsername: Bool {
        let usernameRegEx = "^[A-Z0-9a-z_]{3,13}$"

        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: self)
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
