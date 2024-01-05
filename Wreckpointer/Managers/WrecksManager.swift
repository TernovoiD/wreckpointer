//
//  WrecksManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

final class WrecksManager {
    
    private let server = HTTPServer.shared
    private let coder = JSONCoder.shared
    private let tokenStorage = HTTPServerToken.shared
    
    func create(wreck: Wreck) async throws {
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        guard let url = URL(string: ServerURL.wrecks.path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, data: encodedWreckData, HTTPMethod: .POST)
    }
    
    func update(wreck: Wreck) async throws {
        guard let uuid = wreck.id,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        let _ = try await server.sendRequest(url: url, data: encodedWreckData, HTTPMethod: .PATCH, loginToken: tokenStorage.get())
    }
    
    func delete(wreck: Wreck) async throws {
        guard let uuid = wreck.id,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: tokenStorage.get())
    }
    
    func loadServerInfo() async throws -> ServerInfoModel {
        guard let url = URL(string: ServerURL.wrecks.path) else {
            throw HTTPError.badURL
        }
        let serverData = try await server.sendRequest(url: url, HTTPMethod: .GET)
        return try coder.decodeItemFromData(data: serverData) as ServerInfoModel
    }
    
    func fetch(wreckID: UUID?) async throws -> Wreck {
        guard let uuid = wreckID,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let wreckData = try await server.sendRequest(url: url, HTTPMethod: .GET)
        return try coder.decodeItemFromData(data: wreckData) as Wreck
    }
}
