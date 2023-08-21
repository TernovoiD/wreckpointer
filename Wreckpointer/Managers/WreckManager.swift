//
//  WreckManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation

class WreckManager {
    
    static let shared = WreckManager()
    
    private let http: HTTPRequestSender
    private let coder: JSONDataCoder
    private let token: AccessTokenHelper
    
    private init() {
        self.http = HTTPRequestSender.shared
        self.coder = JSONDataCoder.shared
        self.token = AccessTokenHelper.shared
    }
    
    func fetchWrecks() async throws -> [Wreck] {
        guard let wrecksURL = URL(string: BaseRoutes.baseURL + Endpoints.wreck) else { throw HTTPError.badURL }
        let data = try await http.sendRequest(toURL: wrecksURL, withHTTPMethod: HTTPMethods.GET.rawValue)
        return try coder.decodeItemsArrayFromData(data: data) as [Wreck]
    }
    
    func create(wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: token.getToken())
        return try coder.decodeItemFromData(data: data) as Wreck
    }
    
    func update(wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try coder.encodeItemToData(item: wreck)
        let wreckID = wreck.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck + "/" + wreckID) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.PATCH.rawValue, withloginToken: token.getToken())
        return try coder.decodeItemFromData(data: data) as Wreck
    }
    
    func delete(wreck: Wreck) async throws {
        let wreckID = wreck.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck + "/" + wreckID) else {
            throw HTTPError.badURL
        }
        let _ = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: token.getToken())
    }
}
