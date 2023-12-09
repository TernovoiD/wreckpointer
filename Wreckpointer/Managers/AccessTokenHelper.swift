//
//  AccessTokenManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.08.2023.
//

import Foundation

class AccessTokenManager {
    private let service = "app.wreckpointer"
    
    static let shared = AccessTokenManager()
    
    private init() { }
    
    func saveAccessToken(_ token: String) -> Bool {
        guard let tokenData = token.data(using: .utf8) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: tokenData
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecReturnAttributes as String: kCFBooleanTrue!
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess,
           let existingItem = item as? [String: Any],
           let tokenData = existingItem[kSecValueData as String] as? Data,
           let token = String(data: tokenData, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
    
    func updateAccessToken(_ newToken: String) -> Bool {
        if getToken() != nil {
            return saveAccessToken(newToken)
        }
        return false
    }
    
    func deleteAccessToken() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
