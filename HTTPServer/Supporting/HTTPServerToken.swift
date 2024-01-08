//
//  AccessTokenHelper.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 20.08.2023.
//

import Foundation

class HTTPServerToken {
    private let service = "app.wreckpointer"
    
    static let shared = HTTPServerToken()
    
    private init() { }
    
    func save(_ token: String) throws {
        guard let tokenData = token.data(using: .utf8) else {
            throw HTTPError.notDecodable("Error: Token encode failure")
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: tokenData
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let _ = SecItemAdd(query as CFDictionary, nil)
    }
    
    func get() -> String? {
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
    
    func delete() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if !(status == errSecSuccess || status == errSecItemNotFound) {
            throw HTTPError.notDecodable("Error: Token delete failure")
        }
    }
}
