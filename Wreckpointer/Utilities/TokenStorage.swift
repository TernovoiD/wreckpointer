//
//  TokenStorage.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class TokenStorage {
    
    static let shared = TokenStorage()
    
    private init() { }
    
    func saveToken(_ token: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "userToken")
    }
    
    func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "userToken")
    }
    
    func deleteToken() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userToken")
    }
}
