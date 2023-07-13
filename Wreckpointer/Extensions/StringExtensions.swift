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
    
    var isValidPassword: Bool {
        return self.count >= 8 ? true : false
    }
    
    var isValidName: Bool {
        return self.count >= 5 ? true : false
    }
}
