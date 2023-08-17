//
//  CollectionManager.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 11.08.2023.
//

import Foundation
import Combine

class CollectionManager {
    
    static let shared = CollectionManager()
    
    private let http: HTTPRequestSender
    private let coder: JSONDataCoder
    private let token: TokenStorage
    
    private init() {
        self.http = HTTPRequestSender.shared
        self.coder = JSONDataCoder.shared
        self.token = TokenStorage.shared
    }
    
    func fetchCollections() async throws -> [Collection] {
        guard let collectionsURL = URL(string: BaseRoutes.baseURL + Endpoints.collections) else { throw HTTPError.badURL }
        let data = try await http.sendRequest(toURL: collectionsURL, withHTTPMethod: HTTPMethods.GET.rawValue)
        return try coder.decodeItemsArrayFromData(data: data) as [Collection]
    }
    
    
    func create(collection: Collection) async throws -> Collection {
        let encodedCollectionData = try coder.encodeItemToData(item: collection)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedCollectionData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: token.getToken())
        return try coder.decodeItemFromData(data: data) as Collection
    }
    
    func update(collection: Collection) async throws -> Collection {
        let encodedCollectionData = try coder.encodeItemToData(item: collection)
        let collectionID = collection.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID) else {
            throw HTTPError.badURL
        }
        let data = try await http.sendRequest(toURL: url, withData: encodedCollectionData, withHTTPMethod: HTTPMethods.PATCH.rawValue, withloginToken: token.getToken())
        return try coder.decodeItemFromData(data: data) as Collection
    }
    
    func delete(collection: Collection) async throws {
        let collectionID = collection.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID) else {
            throw HTTPError.badURL
        }
        let _ = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: token.getToken())
    }
}


// MARK: - Collection blocks

extension CollectionManager {
    
        func addBlock(_ block: Block, toCollectionWithID collectionID: UUID?) async throws -> Block {
            let id = collectionID?.uuidString ?? ""
            let encodedBlockData = try coder.encodeItemToData(item: block)
            guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + id + "/" + "blocks") else {
                throw HTTPError.badURL
            }
            let data = try await http.sendRequest(toURL: url, withData: encodedBlockData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: token.getToken())
            return try coder.decodeItemFromData(data: data) as Block
        }
    
        func updateBlock(_ block: Block, inCollectionWithID collectionID: UUID?) async throws -> Block {
            let id = collectionID?.uuidString ?? ""
            let blockID = block.id?.uuidString ?? "error"
            let encodedBlockData = try coder.encodeItemToData(item: block)
            guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + id + "/" + "blocks" + "/" + blockID) else {
                throw HTTPError.badURL
            }
            let data = try await http.sendRequest(toURL: url, withData: encodedBlockData, withHTTPMethod: HTTPMethods.PATCH.rawValue, withloginToken: token.getToken())
            return try coder.decodeItemFromData(data: data) as Block
        }
    
        func removeBlock(_ block: Block, fromCollectionWithID collectionID: UUID?) async throws {
            let id = collectionID?.uuidString ?? ""
            let blockID = block.id?.uuidString ?? "error"
            guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + id + "/" + "blocks" + "/" + blockID) else {
                throw HTTPError.badURL
            }
            let _ = try await http.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: token.getToken())
        }
}
