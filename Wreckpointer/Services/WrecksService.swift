//
//  WrecksService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 16.07.2023.
//

import Foundation

class WrecksService {
    
    let authManager: AuthorizationManager
    let httpManager: HTTPRequestManager
    let dataCoder: JSONDataCoder
    
    init(authManager: AuthorizationManager, httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.authManager = authManager
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
    
    func createWreck(_ wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try dataCoder.encodeItemToData(item: wreck)
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck) else {
            throw HTTPError.badURL
        }
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.POST.rawValue, withloginToken: authManager.getToken())
        let createdWreck = try dataCoder.decodeItemFromData(data: data) as Wreck
        return createdWreck
    }
    
    func updateWreck(_ wreck: Wreck) async throws -> Wreck {
        let encodedWreckData = try dataCoder.encodeItemToData(item: wreck)
        let wreckID = wreck.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck + "/" + wreckID) else {
            throw HTTPError.badURL
        } 
        let data = try await httpManager.sendRequest(toURL: url, withData: encodedWreckData, withHTTPMethod: HTTPMethods.PATCH.rawValue, withloginToken: authManager.getToken())
        let updatedWreck = try dataCoder.decodeItemFromData(data: data) as Wreck
        return updatedWreck
    }
    
    func deleteWreck(_ wreck: Wreck) async throws {
        let wreckID = wreck.id?.uuidString ?? "error"
        guard let url = URL(string: BaseRoutes.baseURL + Endpoints.wreck + "/" + wreckID) else {
            throw HTTPError.badURL
        }
        let _ = try await httpManager.sendRequest(toURL: url, withHTTPMethod: HTTPMethods.DELETE.rawValue, withloginToken: authManager.getToken())
    }
    
    
}
