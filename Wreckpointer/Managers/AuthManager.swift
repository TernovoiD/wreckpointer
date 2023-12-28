//
//  AuthManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

import Foundation

final class AuthManager {
    
    private let server = HTTPServer.shared
    private let coder = JSONCoder.shared
    private let tokenStorage = HTTPServerToken.shared
   
    func authorize(login: String, password: String) async throws {
        let basicAuth = createBasicAuthorization(login: login, password: password)
        guard let url = URL(string: ServerURL.login.path) else {
            throw HTTPError.badURL
        }
        let tokenData = try await server.sendRequest(url: url, HTTPMethod: .POST, basicAuthorization: basicAuth)
        let token = try coder.decodeItemFromData(data: tokenData) as String
        try tokenStorage.save(token)
    }
    
    func checkAuthorizationStatus() async throws -> User {
        guard let url = URL(string: ServerURL.login.path) else {
            throw HTTPError.badURL
        }
        let userData = try await server.sendRequest(url: url, HTTPMethod: .GET, loginToken: tokenStorage.get())
        return try coder.decodeItemFromData(data: userData) as User
    }
    
    private func createBasicAuthorization(login: String, password: String) -> String {
        let loginString = String(format: "%@:%@", login, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
    
}
