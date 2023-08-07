//
//  CollectionsService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 17.07.2023.
//

import Foundation


class CollectionsService {
    
    let authManager: AuthorizationManager
    let httpManager: HTTPRequestManager
    let dataCoder: JSONDataCoder
    
    init(authManager: AuthorizationManager, httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
    
    func getCollections() async throws -> [Collection] {
        guard let collectionsURL = URL(string: BaseRoutes.baseURL + Endpoints.collections) else { throw HTTPError.badURL }
        let data = try await httpManager.sendRequest(toURL: collectionsURL, withHTTPMethod: HTTPMethods.GET.rawValue)
        return try dataCoder.decodeItemsArrayFromData(data: data) as [Collection]
    }
    
    func create(collection: Collection) async throws -> Collection {
        let encodedCollectionData = try dataCoder.encodeItemToData(item: collection)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedCollectionData, withHTTPMethod: HTTPMethods.POST.rawValue)
        let createdCollection = try dataCoder.decodeItemFromData(data: data) as Collection
        return createdCollection
    }
    
    func update(collection: Collection) async throws -> Collection {
        let encodedCollectionData = try dataCoder.encodeItemToData(item: collection)
        let collectionID = collection.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedCollectionData, withHTTPMethod: HTTPMethods.PATCH.rawValue)
        let updatedCollection = try dataCoder.decodeItemFromData(data: data) as Collection
        return updatedCollection
    }
    
    func delete(collection: Collection) async throws {
        let collectionID = collection.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID) else {
            throw HTTPError.badURL
        }
        let _ = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue)
    }
    
    func addBlock(_ block: Block, toCollection collection: Collection) async throws -> Block {
        let collectionID = collection.id?.uuidString ?? "error"
        let encodedBlockData = try dataCoder.encodeItemToData(item: block)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID + "/" + "blocks") else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedBlockData, withHTTPMethod: HTTPMethods.POST.rawValue)
        let createdBlock = try dataCoder.decodeItemFromData(data: data) as Block
        return createdBlock
    }
    
    func updateBlock(_ block: Block, inCollection collection: Collection) async throws -> Block {
        let collectionID = collection.id?.uuidString ?? "error"
        let blockID = block.id ?? "error"
        let encodedBlockData = try dataCoder.encodeItemToData(item: block)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID + "/" + "blocks" + "/" + blockID) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedBlockData, withHTTPMethod: HTTPMethods.PATCH.rawValue)
        let updatedBlock = try dataCoder.decodeItemFromData(data: data) as Block
        return updatedBlock
    }
    
    func removeBlock(_ block: Block, fromCollection collection: Collection) async throws {
        let collectionID = collection.id?.uuidString ?? "error"
        let blockID = block.id ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.collections + "/" + collectionID + "/" + "blocks" + "/" + blockID) else {
            throw HTTPError.badURL
        }
        let _ = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue)
    }
    
}
