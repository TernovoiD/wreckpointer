//
//  WreckService.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.07.2023.
//

import Foundation

class WreckService {
    
    let httpManager: HTTPRequestManager
    let dataCoder: JSONDataCoder
    
    init(httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
    
//    func updateWrecks(lastUpdate: Date) async throws {
//        let updatedWrecks = try await requestUpdatedWrecks(fromDate: lastUpdate)
//        let (wrecksData, _) = try wrecksCDManager.fetchWrecks()
//        var coreDataWrecks = try decodeWrecks(data: wrecksData)
//        for wreck in updatedWrecks {
//            coreDataWrecks.removeAll(where: { $0.id == wreck.id })
//            coreDataWrecks.append(wreck)
//        }
//
//        try wrecksCDManager.deleteWrecks()
//        let encodedWrecks = try encodeWrecks(wrecks: updatedWrecks)
//        try wrecksCDManager.addWrecks(wrecksData: encodedWrecks)
//    }
    
//    func downloadWrecks() async throws -> ([Wreck], Date) {
//        let (wrecksData, lastUpdateTime) = try wrecksCDManager.fetchWrecks()
//        if wrecksData.isEmpty {
//            let wrecks = try await downloadWrecksFromServer()
//            let loadedWrecksData = try encodeWrecks(wrecks: wrecks)
//            try wrecksCDManager.addWrecks(wrecksData: loadedWrecksData)
//            return (wrecks, lastUpdateTime)
//        } else {
//            let wrecks = try decodeWrecks(data: wrecksData)
//            return (wrecks, lastUpdateTime)
//        }
//    }
    
    func requestUpdatedWrecks(fromDate lastUpdate: Date) async throws -> [Wreck] {
        let lastUpdateTimeData = try dataCoder.encodeItemToData(item: lastUpdate)
        guard let wrecksURL = URL(string: BaseRoutes.baseURL + Endpoints.wreck + "/update") else { throw HTTPError.badURL }
        let data = try await httpManager.sendRequest(toURL: wrecksURL, withData: lastUpdateTimeData, withHTTPMethod: HTTPMethods.POST.rawValue)
        return try dataCoder.decodeItemsArrayFromData(data: data) as [Wreck]
    }
    
    func downloadWrecksFromServer() async throws -> [Wreck] {
        guard let wrecksURL = URL(string: BaseRoutes.baseURL + Endpoints.wreck) else { throw HTTPError.badURL }
        let data = try await httpManager.sendRequest(toURL: wrecksURL, withHTTPMethod: HTTPMethods.GET.rawValue)
        return try dataCoder.decodeItemsArrayFromData(data: data) as [Wreck]
    }
    
    private func encodeWrecks(wrecks: [Wreck]) throws -> [Data] {
        var wrecksData: [Data] = [ ]
        for wreck in wrecks {
            let wreckData = try dataCoder.encodeItemToData(item: wreck)
            wrecksData.append(wreckData)
        }
        return wrecksData
    }
    
    private func decodeWrecks(data: [Data]) throws -> [Wreck] {
        var wrecks: [Wreck] = [ ]
        for datum in data {
            let wreck = try dataCoder.decodeItemFromData(data: datum) as Wreck
            wrecks.append(wreck)
        }
        return wrecks
    }
}
