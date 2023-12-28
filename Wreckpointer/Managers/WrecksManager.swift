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
    
    func create(wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        guard let url = URL(string: ServerURL.wrecks.path) else {
            throw HTTPError.badURL
        }
        let createdWreckData = try await server.sendRequest(url: url, data: encodedWreckData, HTTPMethod: .POST)
        return try coder.decodeItemFromData(data: createdWreckData) as Wreck
    }
    
    func update(wreck: Wreck) async throws -> Wreck {
        guard let uuid = wreck.id,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        let updatedWreckData = try await server.sendRequest(url: url, data: encodedWreckData, HTTPMethod: .PATCH, loginToken: tokenStorage.get())
        return try coder.decodeItemFromData(data: updatedWreckData) as Wreck
    }
    
    func delete(wreck: Wreck) async throws {
        guard let uuid = wreck.id,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: tokenStorage.get())
    }
    
    func fetchAll() async throws -> [Wreck] {
        guard let url = URL(string: ServerURL.wrecks.path) else {
            throw HTTPError.badURL
        }
        let wrecksData = try await server.sendRequest(url: url, HTTPMethod: .GET)
        return try coder.decodeArrayFromData(data: wrecksData) as [Wreck]
    }
    
    func fetch(wreckID: UUID?) async throws -> Wreck {
        guard let uuid = wreckID,
              let url = URL(string: ServerURL.wreck(uuid).path) else {
            throw HTTPError.badURL
        }
        let wreckData = try await server.sendRequest(url: url, HTTPMethod: .GET)
        return try coder.decodeItemFromData(data: wreckData) as Wreck
    }
    
    func add(image: WreckImage, toWreck wreckID: UUID?) async throws -> WreckImage {
        guard let uuid = wreckID,
              let url = URL(string: ServerURL.wreckImages(uuid).path) else {
            throw HTTPError.badURL
        }
        let wreckImageData = try await server.sendRequest(url: url, HTTPMethod: .POST, loginToken: tokenStorage.get())
        return try coder.decodeItemFromData(data: wreckImageData) as WreckImage
    }
    
    func remove(imageID: UUID?, toWreck wreckID: UUID?) async throws {
        guard let uuidWreck = wreckID,
              let uuidImage = imageID,
              let url = URL(string: ServerURL.wreckImage(uuidWreck, uuidImage).path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, HTTPMethod: .DELETE, loginToken: tokenStorage.get())
    }
    
    func changeApprovedStatus(_ status: Bool, wreckID: UUID?) async throws {
        guard let uuidWreck = wreckID,
              let url = URL(string: ServerURL.wreckApprovedStatus(uuidWreck).path) else {
            throw HTTPError.badURL
        }
        let _ = try await server.sendRequest(url: url, HTTPMethod: .POST, loginToken: tokenStorage.get())
    }
}
