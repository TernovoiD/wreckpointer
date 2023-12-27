//
//  WrecksManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class WrecksManager {
    
    private let http: HTTPRequestSender
    private let coder: JSONDataCoder
    
    public init() {
        self.http = HTTPRequestSender.shared
        self.coder = JSONDataCoder.shared
    }
    
    func fetch() async throws -> [Wreck] {
        guard let wrecksURL = URL(string: Endpoints.wrecks.path) else { throw HTTPError.badURL }
        let serverResponseData = try await http.sendRequest(toURL: wrecksURL, withHTTPMethod: HTTPMethods.GET.rawValue)
        return try coder.decodeArrayFromData(data: serverResponseData) as [Wreck]
    }
    
    func create(wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        guard let url = URL(string: Endpoints.wrecks.path) else {
            throw HTTPError.badURL
        }
        let serverResponseData = try await http.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.POST.rawValue)
        return try coder.decodeItemFromData(data: serverResponseData) as Wreck
    }
    
    func update(wreck: Wreck) async throws -> Wreck {
        guard let uuid = wreck.id,
              let url = URL(string: Endpoints.wreck(uuid).path) else {
                  throw HTTPError.badURL
              }
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        let serverResponseData = try await http.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.PATCH.rawValue)
        return try coder.decodeItemFromData(data: serverResponseData) as Wreck
    }
    
    func delete(wreck: Wreck) async throws {
        guard let uuid = wreck.id,
              let url = URL(string: Endpoints.wreck(uuid).path) else {
                  throw HTTPError.badURL
              }
        let _ = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue)
    }
}
