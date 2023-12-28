//
//  ModeratorsManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 27.12.2023.
//

import Foundation

final class ModeratorsManager {
    
    private let server = HTTPServer.shared
    private let coder = JSONCoder.shared
    private let tokenStorage = HTTPServerToken.shared
    
    struct UserCreate: Codable {
        let username: String
        let password: String
    }
    
    func add(username: String, password: String) async throws -> User {
        let user = UserCreate(username: username, password: password)
        guard let url = URL(string: ServerURL.moderators.path) else {
            throw HTTPError.badURL
        }
        let encodedUserData = try coder.encodeItemToData(item: user)
        let createdModeratorData = try await server.sendRequest(url: url, data: encodedUserData, HTTPMethod: .POST, loginToken: tokenStorage.get())
        return try coder.decodeItemFromData(data: createdModeratorData) as User
    }
    
    func delete(moderatorID: UUID?) async throws {
        guard let uuid = moderatorID,
              let url = URL(string: ServerURL.moderator(uuid).path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: tokenStorage.get())
    }
}
