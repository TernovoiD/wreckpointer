//
//  WrecksLoader.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 10.07.2023.
//

import Foundation

class WrecksLoader {
    
    let httpManager: HTTPRequestManager
    let dataCoder: JSONDataCoder
    
    init(httpManager: HTTPRequestManager, dataCoder: JSONDataCoder) {
        self.httpManager = httpManager
        self.dataCoder = dataCoder
    }
    
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
